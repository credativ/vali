package ruler

import (
	"github.com/cortexproject/cortex/pkg/ruler"
	cRules "github.com/cortexproject/cortex/pkg/ruler/rules"
	"github.com/go-kit/kit/log"
	"github.com/pkg/errors"
	"github.com/prometheus/client_golang/prometheus"

	"github.com/credativ/vali/pkg/logql"
	"github.com/credativ/vali/pkg/ruler/manager"
)

type Config struct {
	ruler.Config `yaml:",inline"`
}

// Override the embedded cortex variant which expects a cortex limits struct. Instead copy the relevant bits over.
func (cfg *Config) Validate() error {
	if err := cfg.StoreConfig.Validate(); err != nil {
		return errors.Wrap(err, "invalid storage config")
	}
	return nil
}

func NewRuler(cfg Config, engine *logql.Engine, reg prometheus.Registerer, logger log.Logger, ruleStore cRules.RuleStore, limits ruler.RulesLimits) (*ruler.Ruler, error) {
	mgr, err := ruler.NewDefaultMultiTenantManager(
		cfg.Config,
		manager.MemstoreTenantManager(
			cfg.Config,
			engine,
			limits,
		),
		prometheus.DefaultRegisterer,
		logger,
	)
	if err != nil {
		return nil, err
	}
	return ruler.NewRuler(
		cfg.Config,
		manager.MultiTenantManagerAdapter(mgr),
		reg,
		logger,
		ruleStore,
		limits,
	)
}
