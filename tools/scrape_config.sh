#!/bin/sh

##########################################
# Generate the scrape_config for the
# valitail.sh script and the helm chart.
#
# The scrape_config is built from the
# scrape_config defined in the valitail
# ksonnet library.
#########################################

BASE=$(dirname $0)

target=${1:-shell}

case $target in
    "shell")
        (cd $BASE; jsonnet -e '((import "../production/ksonnet/valitail/scrape_config.libsonnet") + { _config:: { valitail_config: { pipeline_stages: ["<parser>"]}}}).valitail_config' | ytools 2>/dev/null)
        ;;

    *)
        echo "unknown target. expected 'shell' or 'helm'"
        exit 1
esac
