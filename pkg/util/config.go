package util

import (
	"fmt"
	"io"
	"strings"

	util_log "github.com/cortexproject/cortex/pkg/util/log"
	"github.com/go-kit/kit/log/level"
	"github.com/prometheus/common/version"
	"gopkg.in/yaml.v2"
)

// LogConfig takes a pointer to a config object, marshalls it to YAML and prints each line in REVERSE order
// The reverse order makes display in Plutono in easier which typically sorts newest entries at the top.
func LogConfig(cfg interface{}) error {
	lc, err := yaml.Marshal(cfg)
	if err != nil {
		return err
	}

	cfgStr := string(lc)
	cfgStrs := strings.Split(cfgStr, "\n")
	for i := len(cfgStrs) - 1; i >= 0; i-- {
		level.Info(util_log.Logger).Log("type", "config", "msg", cfgStrs[i])
	}
	return nil
}

// PrintConfig will takes a pointer to a config object, marshalls it to YAML and prints the result to the provided writer
// unlike LogConfig, PrintConfig prints the object in naturally ocurring order.
func PrintConfig(w io.Writer, config interface{}) error {
	lc, err := yaml.Marshal(config)
	if err != nil {
		return err
	}
	fmt.Fprintf(w, "---\n# Vali Config\n# %s\n%s\n\n", version.Info(), string(lc))
	return nil
}
