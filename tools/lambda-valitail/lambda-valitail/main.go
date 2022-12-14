package main

import (
	"bufio"
	"bytes"
	"context"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/cortexproject/cortex/pkg/util"
	"github.com/gogo/protobuf/proto"
	"github.com/golang/snappy"
	"github.com/prometheus/common/model"

	"github.com/credativ/vali/pkg/logproto"
)

const (
	// We use snappy-encoded protobufs over http by default.
	contentType = "application/x-protobuf"

	maxErrMsgLen = 1024
)

var valitailAddress *url.URL

func init() {
	addr := os.Getenv("VALITAIL_ADDRESS")
	if addr == "" {
		panic(errors.New("required environmental variable VALITAIL_ADDRESS not present"))
	}
	var err error
	valitailAddress, err = url.Parse(addr)
	if err != nil {
		panic(err)
	}
}

func handler(ctx context.Context, ev events.CloudwatchLogsEvent) error {

	data, err := ev.AWSLogs.Parse()
	if err != nil {
		return err
	}

	stream := logproto.Stream{
		Labels: model.LabelSet{
			model.LabelName("__aws_cloudwatch_log_group"):  model.LabelValue(data.LogGroup),
			model.LabelName("__aws_cloudwatch_log_stream"): model.LabelValue(data.LogStream),
			model.LabelName("__aws_cloudwatch_owner"):      model.LabelValue(data.Owner),
		}.String(),
		Entries: make([]logproto.Entry, 0, len(data.LogEvents)),
	}

	for _, entry := range data.LogEvents {
		stream.Entries = append(stream.Entries, logproto.Entry{
			Line: entry.Message,
			// It's best practice to ignore timestamps from cloudwatch as valitail is responsible for adding those.
			Timestamp: util.TimeFromMillis(entry.Timestamp),
		})
	}

	buf, err := proto.Marshal(&logproto.PushRequest{
		Streams: []logproto.Stream{stream},
	})
	if err != nil {
		return err
	}

	// Push to valitail
	buf = snappy.Encode(nil, buf)
	req, err := http.NewRequest("POST", valitailAddress.String(), bytes.NewReader(buf))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", contentType)

	resp, err := http.DefaultClient.Do(req.WithContext(ctx))
	if err != nil {
		return err
	}

	if resp.StatusCode/100 != 2 {
		scanner := bufio.NewScanner(io.LimitReader(resp.Body, maxErrMsgLen))
		line := ""
		if scanner.Scan() {
			line = scanner.Text()
		}
		err = fmt.Errorf("server returned HTTP status %s (%d): %s", resp.Status, resp.StatusCode, line)
	}

	return err
}

func main() {
	lambda.Start(handler)
}
