local utils = import 'mixin-utils/utils.libsonnet';

{
  prometheusRules+:: {
    groups+: [{
      name: 'vali_rules',
      rules:
        utils.histogramRules('vali_request_duration_seconds', ['job']) +
        utils.histogramRules('vali_request_duration_seconds', ['job', 'route']) +
        utils.histogramRules('vali_request_duration_seconds', ['namespace', 'job', 'route']),
    }],
  },
}
