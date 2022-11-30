package valitail

import (
	"sync"

	util_log "github.com/cortexproject/cortex/pkg/util/log"
	"github.com/go-kit/kit/log"
	"github.com/prometheus/client_golang/prometheus"

	"github.com/credativ/vali/pkg/valitail/client"
	"github.com/credativ/vali/pkg/valitail/config"
	"github.com/credativ/vali/pkg/valitail/server"
	"github.com/credativ/vali/pkg/valitail/targets"
)

// Option is a function that can be passed to the New method of Valitail and
// customize the Valitail that is created.
type Option func(p *Valitail)

// WithLogger overrides the default logger for Valitail.
func WithLogger(log log.Logger) Option {
	return func(p *Valitail) {
		p.logger = log
	}
}

// WithRegisterer overrides the default registerer for Valitail.
func WithRegisterer(reg prometheus.Registerer) Option {
	return func(p *Valitail) {
		p.reg = reg
	}
}

// Valitail is the root struct for Valitail.
type Valitail struct {
	client         client.Client
	targetManagers *targets.TargetManagers
	server         server.Server
	logger         log.Logger
	reg            prometheus.Registerer

	stopped bool
	mtx     sync.Mutex
}

// New makes a new Valitail.
func New(cfg config.Config, dryRun bool, opts ...Option) (*Valitail, error) {
	// Initialize valitail with some defaults and allow the options to override
	// them.
	valitail := &Valitail{
		logger: util_log.Logger,
		reg:    prometheus.DefaultRegisterer,
	}
	for _, o := range opts {
		o(valitail)
	}

	if cfg.ClientConfig.URL.URL != nil {
		// if a single client config is used we add it to the multiple client config for backward compatibility
		cfg.ClientConfigs = append(cfg.ClientConfigs, cfg.ClientConfig)
	}

	// This is a bit crude but if the Vali Push API target is specified,
	// force the log level to match the valitail log level
	for i := range cfg.ScrapeConfig {
		if cfg.ScrapeConfig[i].PushConfig != nil {
			cfg.ScrapeConfig[i].PushConfig.Server.LogLevel = cfg.ServerConfig.LogLevel
			cfg.ScrapeConfig[i].PushConfig.Server.LogFormat = cfg.ServerConfig.LogFormat
		}
	}

	var err error
	if dryRun {
		valitail.client, err = client.NewLogger(prometheus.DefaultRegisterer, valitail.logger, cfg.ClientConfig.ExternalLabels, cfg.ClientConfigs...)
		if err != nil {
			return nil, err
		}
		cfg.PositionsConfig.ReadOnly = true
	} else {
		valitail.client, err = client.NewMulti(prometheus.DefaultRegisterer, valitail.logger, cfg.ClientConfig.ExternalLabels, cfg.ClientConfigs...)
		if err != nil {
			return nil, err
		}
	}

	tms, err := targets.NewTargetManagers(valitail, valitail.reg, valitail.logger, cfg.PositionsConfig, valitail.client, cfg.ScrapeConfig, &cfg.TargetConfig)
	if err != nil {
		return nil, err
	}
	valitail.targetManagers = tms
	server, err := server.New(cfg.ServerConfig, valitail.logger, tms)
	if err != nil {
		return nil, err
	}
	valitail.server = server
	return valitail, nil
}

// Run the valitail; will block until a signal is received.
func (p *Valitail) Run() error {
	p.mtx.Lock()
	// if we stopped valitail before the server even started we can return without starting.
	if p.stopped {
		p.mtx.Unlock()
		return nil
	}
	p.mtx.Unlock() // unlock before blocking
	return p.server.Run()
}

// Client returns the underlying client Valitail uses to write to Vali.
func (p *Valitail) Client() client.Client {
	return p.client
}

// Shutdown the valitail.
func (p *Valitail) Shutdown() {
	p.mtx.Lock()
	defer p.mtx.Unlock()
	p.stopped = true
	if p.server != nil {
		p.server.Shutdown()
	}
	if p.targetManagers != nil {
		p.targetManagers.Stop()
	}
	// todo work out the stop.
	p.client.Stop()
}
