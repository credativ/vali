local utils = import 'mixin-utils/utils.libsonnet';

{
  prometheusRules+:: {
    groups+: [{
      name: 'valitail_rules',
      rules:
        utils.histogramRules('valitail_request_duration_seconds', ['job']) +
        utils.histogramRules('valitail_request_duration_seconds', ['job', 'namespace']) +
        utils.histogramRules('valitail_request_duration_seconds', ['job', 'status_code', 'namespace']),
    }],
  },
}
