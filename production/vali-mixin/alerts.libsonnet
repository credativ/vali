{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'vali_alerts',
        rules: [
          {
            alert: 'ValiRequestErrors',
            expr: |||
              100 * sum(rate(vali_request_duration_seconds_count{status_code=~"5.."}[1m])) by (namespace, job, route)
                /
              sum(rate(vali_request_duration_seconds_count[1m])) by (namespace, job, route)
                > 10
            |||,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: |||
                {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}% errors.
              |||,
            },
          },
          {
            alert: 'ValiRequestPanics',
            expr: |||
              sum(increase(vali_panic_total[10m])) by (namespace, job) > 0
            |||,
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: |||
                {{ $labels.job }} is experiencing {{ printf "%.2f" $value }}% increase of panics.
              |||,
            },
          },
          {
            alert: 'ValiRequestLatency',
            expr: |||
              namespace_job_route:vali_request_duration_seconds:99quantile{route!~"(?i).*tail.*"} > 1
            |||,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: |||
                {{ $labels.job }} {{ $labels.route }} is experiencing {{ printf "%.2f" $value }}s 99th percentile latency.
              |||,
            },
          },
        ],
      },
    ],
  },
}
