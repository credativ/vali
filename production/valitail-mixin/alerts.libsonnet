{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'valitail_alerts',
        rules: [
          {
            alert: 'ValitailRequestsErrors',
            expr: |||
              100 * sum(rate(valitail_request_duration_seconds_count{status_code=~"5..|failed"}[1m])) by (namespace, job, route, instance)
                /
              sum(rate(valitail_request_duration_seconds_count[1m])) by (namespace, job, route, instance)
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
            alert: 'ValitailRequestLatency',
            expr: |||
              job_status_code_namespace:valitail_request_duration_seconds:99quantile > 1
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
          {
            alert: 'ValitailFileLagging',
            expr: |||
              abs(valitail_file_bytes_total - valitail_read_bytes_total) > 1e6
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              message: |||
                {{ $labels.instance }} {{ $labels.job }} {{ $labels.path }} has been lagging by more than 1MB for more than 15m.
              |||,
            },
          },
          {
            alert: 'ValitailFileMissing',
            expr: |||
              valitail_file_bytes_total unless valitail_read_bytes_total
            |||,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: |||
                {{ $labels.instance }} {{ $labels.job }} {{ $labels.path }} matches the glob but is not being tailed.
              |||,
            },
          },
        ],
      },
    ],
  },
}
