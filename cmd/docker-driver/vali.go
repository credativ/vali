package main

import (
	"bytes"

	"github.com/docker/docker/daemon/logger"
	"github.com/go-kit/kit/log"
	"github.com/go-kit/kit/log/level"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/common/model"

	"github.com/credativ/vali/pkg/logentry/stages"
	"github.com/credativ/vali/pkg/logproto"
	"github.com/credativ/vali/pkg/valitail/api"
	"github.com/credativ/vali/pkg/valitail/client"
)

var jobName = "docker"

type vali struct {
	client  client.Client
	handler api.EntryHandler
	labels  model.LabelSet
	logger  log.Logger

	stop func()
}

// New create a new Vali logger that forward logs to Vali instance
func New(logCtx logger.Info, logger log.Logger) (logger.Logger, error) {
	logger = log.With(logger, "container_id", logCtx.ContainerID)
	cfg, err := parseConfig(logCtx)
	if err != nil {
		return nil, err
	}
	c, err := client.New(prometheus.DefaultRegisterer, cfg.clientConfig, logger)
	if err != nil {
		return nil, err
	}
	var handler api.EntryHandler = c
	var stop func() = func() {}
	if len(cfg.pipeline.PipelineStages) != 0 {
		pipeline, err := stages.NewPipeline(logger, cfg.pipeline.PipelineStages, &jobName, prometheus.DefaultRegisterer)
		if err != nil {
			return nil, err
		}
		handler = pipeline.Wrap(c)
		stop = handler.Stop
	}
	return &vali{
		client:  c,
		labels:  cfg.labels,
		logger:  logger,
		handler: handler,
		stop:    stop,
	}, nil
}

// Log implements `logger.Logger`
func (l *vali) Log(m *logger.Message) error {
	if len(bytes.Fields(m.Line)) == 0 {
		level.Debug(l.logger).Log("msg", "ignoring empty line", "line", string(m.Line))
		return nil
	}
	lbs := l.labels.Clone()
	if m.Source != "" {
		lbs["source"] = model.LabelValue(m.Source)
	}
	l.handler.Chan() <- api.Entry{
		Labels: lbs,
		Entry: logproto.Entry{
			Timestamp: m.Timestamp,
			Line:      string(m.Line),
		},
	}
	return nil
}

// Log implements `logger.Logger`
func (l *vali) Name() string {
	return driverName
}

// Log implements `logger.Logger`
func (l *vali) Close() error {
	l.stop()
	l.client.StopNow()
	return nil
}
