local g = import 'plutono-builder/plutono.libsonnet';
local utils = import 'mixin-utils/utils.libsonnet';

{
  plutonoDashboards+: {
    local dashboards = self,

    'valitail.json':{
      local cfg = self,

      showMultiCluster:: true,
      clusterLabel:: 'cluster',
      clusterMatchers:: if cfg.showMultiCluster then [utils.selector.re(cfg.clusterLabel, '$cluster')] else [],

      matchers:: [utils.selector.eq('job', '$namespace/$name')],
      selector:: std.join(',', ['%(label)s%(op)s"%(value)s"' % matcher for matcher in (cfg.clusterMatchers + dashboards['valitail.json'].matchers)]),

      templateLabels:: (
        if cfg.showMultiCluster then [
          {
            variable:: 'cluster',
            label:: cfg.clusterLabel,
            query:: 'kube_pod_container_info{image=~".*valitail.*"}',
          },
        ] else []
      ) + [
        {
          variable:: 'namespace',
          label:: 'namespace',
          query:: 'kube_pod_container_info{image=~".*valitail.*"}',
        },
        {
          variable:: 'name',
          label:: 'created_by_name',
          query:: 'kube_pod_info{namespace="$namespace",pod=~"valitail.*"}',
        },
      ],
    } +
    g.dashboard('Vali / Valitail')
    .addRow(
      g.row('Targets & Files')
      .addPanel(
        g.panel('Active Targets') +
        g.queryPanel(
          'sum(valitail_targets_active_total{%s})' % dashboards['valitail.json'].selector,
          'Active Targets',
        ),
      )
      .addPanel(
        g.panel('Active Files') +
        g.queryPanel(
          'sum(valitail_files_active_total{%s})' % dashboards['valitail.json'].selector,
          'Active Targets',
        ),
      )
    )
    .addRow(
      g.row('IO')
      .addPanel(
        g.panel('Bps') +
        g.queryPanel(
          'sum(rate(valitail_read_bytes_total{%s}[1m]))' % dashboards['valitail.json'].selector,
          'logs read',
        ) +
        { yaxes: g.yaxes('Bps') },
      )
      .addPanel(
        g.panel('Lines') +
        g.queryPanel(
          'sum(rate(valitail_read_lines_total{%s}[1m]))' % dashboards['valitail.json'].selector,
          'lines read',
        ),
      )
    )
    .addRow(
      g.row('Requests')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('valitail_request_duration_seconds_count{%s}' % dashboards['valitail.json'].selector)
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'valitail_request_duration_seconds',
          dashboards['valitail.json'].matchers,
          extra_selectors=dashboards['valitail.json'].clusterMatchers
        )
      )
    ){
      templating+: {
        list+: [
          {
            allValue: null,
            current: {
              text: 'prod',
              value: 'prod',
            },
            datasource: '$datasource',
            hide: 0,
            includeAll: false,
            label: l.variable,
            multi: false,
            name: l.variable,
            options: [

            ],
            query: 'label_values(%s, %s)' % [l.query, l.label],
            refresh: 1,
            regex: '',
            sort: 2,
            tagValuesQuery: '',
            tags: [

            ],
            tagsQuery: '',
            type: 'query',
            useTags: false,
          }
          for l in dashboards['valitail.json'].templateLabels
        ],
      },
    },
  },
}
