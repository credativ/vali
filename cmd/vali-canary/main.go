package main

import (
	"flag"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"strconv"
	"sync"
	"syscall"
	"time"

	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/prometheus/common/version"

	_ "github.com/credativ/vali/pkg/build"
	"github.com/credativ/vali/pkg/canary/comparator"
	"github.com/credativ/vali/pkg/canary/reader"
	"github.com/credativ/vali/pkg/canary/writer"
)

type canary struct {
	lock sync.Mutex

	writer     *writer.Writer
	reader     *reader.Reader
	comparator *comparator.Comparator
}

func main() {

	lName := flag.String("labelname", "name", "The label name for this instance of vali-canary to use in the log selector")
	lVal := flag.String("labelvalue", "vali-canary", "The unique label value for this instance of vali-canary to use in the log selector")
	sName := flag.String("streamname", "stream", "The stream name for this instance of vali-canary to use in the log selector")
	sValue := flag.String("streamvalue", "stdout", "The unique stream value for this instance of vali-canary to use in the log selector")
	port := flag.Int("port", 3500, "Port which vali-canary should expose metrics")
	addr := flag.String("addr", "", "The Vali server URL:Port, e.g. vali:3100")
	tls := flag.Bool("tls", false, "Does the vali connection use TLS?")
	user := flag.String("user", "", "Vali username")
	pass := flag.String("pass", "", "Vali password")
	queryTimeout := flag.Duration("query-timeout", 10*time.Second, "How long to wait for a query response from Vali")

	interval := flag.Duration("interval", 1000*time.Millisecond, "Duration between log entries")
	size := flag.Int("size", 100, "Size in bytes of each log line")
	wait := flag.Duration("wait", 60*time.Second, "Duration to wait for log entries on websocket before querying vali for them")
	maxWait := flag.Duration("max-wait", 5*time.Minute, "Duration to keep querying Vali for missing websocket entries before reporting them missing")
	pruneInterval := flag.Duration("pruneinterval", 60*time.Second, "Frequency to check sent vs received logs, "+
		"also the frequency which queries for missing logs will be dispatched to vali")
	buckets := flag.Int("buckets", 10, "Number of buckets in the response_latency histogram")

	metricTestInterval := flag.Duration("metric-test-interval", 1*time.Hour, "The interval the metric test query should be run")
	metricTestQueryRange := flag.Duration("metric-test-range", 24*time.Hour, "The range value [24h] used in the metric test instant-query."+
		" Note: this value is truncated to the running time of the canary until this value is reached")

	spotCheckInterval := flag.Duration("spot-check-interval", 15*time.Minute, "Interval that a single result will be kept from sent entries and spot-checked against Vali, "+
		"e.g. 15min default one entry every 15 min will be saved and then queried again every 15min until spot-check-max is reached")
	spotCheckMax := flag.Duration("spot-check-max", 4*time.Hour, "How far back to check a spot check entry before dropping it")
	spotCheckQueryRate := flag.Duration("spot-check-query-rate", 1*time.Minute, "Interval that the canary will query Vali for the current list of all spot check entries")
	spotCheckWait := flag.Duration("spot-check-initial-wait", 10*time.Second, "How long should the spot check query wait before starting to check for entries")

	printVersion := flag.Bool("version", false, "Print this builds version information")

	flag.Parse()

	if *printVersion {
		fmt.Println(version.Print("vali-canary"))
		os.Exit(0)
	}

	if *addr == "" {
		_, _ = fmt.Fprintf(os.Stderr, "Must specify a Vali address with -addr\n")
		os.Exit(1)
	}

	sentChan := make(chan time.Time)
	receivedChan := make(chan time.Time)

	c := &canary{}
	startCanary := func() {
		c.stop()

		c.lock.Lock()
		defer c.lock.Unlock()

		c.writer = writer.NewWriter(os.Stdout, sentChan, *interval, *size)
		c.reader = reader.NewReader(os.Stderr, receivedChan, *tls, *addr, *user, *pass, *queryTimeout, *lName, *lVal, *sName, *sValue, *interval)
		c.comparator = comparator.NewComparator(os.Stderr, *wait, *maxWait, *pruneInterval, *spotCheckInterval, *spotCheckMax, *spotCheckQueryRate, *spotCheckWait, *metricTestInterval, *metricTestQueryRange, *interval, *buckets, sentChan, receivedChan, c.reader, true)
	}

	startCanary()

	http.HandleFunc("/resume", func(_ http.ResponseWriter, _ *http.Request) {
		_, _ = fmt.Fprintf(os.Stderr, "restarting\n")
		startCanary()
	})
	http.HandleFunc("/suspend", func(_ http.ResponseWriter, _ *http.Request) {
		_, _ = fmt.Fprintf(os.Stderr, "suspending\n")
		c.stop()
	})
	http.Handle("/metrics", promhttp.Handler())
	go func() {
		err := http.ListenAndServe(":"+strconv.Itoa(*port), nil)
		if err != nil {
			panic(err)
		}
	}()

	terminate := make(chan os.Signal, 1)
	signal.Notify(terminate, syscall.SIGTERM, os.Interrupt)

	for range terminate {
		_, _ = fmt.Fprintf(os.Stderr, "shutting down\n")
		c.stop()
		return
	}
}

func (c *canary) stop() {
	c.lock.Lock()
	defer c.lock.Unlock()

	if c.writer == nil || c.reader == nil || c.comparator == nil {
		return
	}

	c.writer.Stop()
	c.reader.Stop()
	c.comparator.Stop()

	c.writer = nil
	c.reader = nil
	c.comparator = nil
}
