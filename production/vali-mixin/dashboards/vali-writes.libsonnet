local g = import 'grafana-builder/grafana.libsonnet';
local utils = import 'mixin-utils/utils.libsonnet';

{
  grafanaDashboards+: {
    local dashboards = self,

    'vali-writes.json': {
      local cfg = self,

      showMultiCluster:: true,
      clusterLabel:: 'cluster',
      clusterMatchers::
        if cfg.showMultiCluster then
          [utils.selector.re(cfg.clusterLabel, '$cluster')]
        else
          [],

      namespaceType:: 'query',
      namespaceQuery::
        if cfg.showMultiCluster then
          'kube_pod_container_info{cluster="$cluster", image=~".*vali.*"}'
        else
          'kube_pod_container_info{image=~".*vali.*"}',

      assert (cfg.namespaceType == 'custom' || cfg.namespaceType == 'query') : "Only types 'query' and 'custom' are allowed for dashboard variable 'namespace'",

      matchers:: {
        cortexgateway: [utils.selector.re('job', '($namespace)/cortex-gw')],
        distributor: [utils.selector.re('job', '($namespace)/distributor')],
        ingester: [utils.selector.re('job', '($namespace)/ingester')],
      },

      local selector(matcherId) =
        local ms = cfg.clusterMatchers + cfg.matchers[matcherId];
        if std.length(ms) > 0 then
          std.join(',', ['%(label)s%(op)s"%(value)s"' % matcher for matcher in ms]) + ','
        else '',

      cortexGwSelector:: selector('cortexgateway'),
      distributorSelector:: selector('distributor'),
      ingesterSelector:: selector('ingester'),

      templateLabels:: (
        if cfg.showMultiCluster then [
          {
            variable:: 'cluster',
            label:: cfg.clusterLabel,
            query:: 'kube_pod_container_info{image=~".*vali.*"}',
            type:: 'query',
          },
        ] else []
      ) + [
        {
          variable:: 'namespace',
          label:: 'namespace',
          query:: cfg.namespaceQuery,
          type:: cfg.namespaceType,
        },
      ],
    } +
    g.dashboard('Vali / Writes')
    .addRow(
      g.row('Frontend (cortex_gw)')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s route=~"api_prom_push|vali_api_v1_push"}' % dashboards['vali-writes.json'].cortexGwSelector)
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-writes.json'].matchers.cortexgateway + [utils.selector.re('route', 'api_prom_push|vali_api_v1_push')],
          extra_selectors=dashboards['vali-writes.json'].clusterMatchers
        )
      )
    )
    .addRow(
      g.row('Distributor')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s}' % std.rstripChars(dashboards['vali-writes.json'].distributorSelector, ','))
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-writes.json'].matchers.distributor,
          extra_selectors=dashboards['vali-writes.json'].clusterMatchers
        )
      )
    )
    .addRow(
      g.row('Ingester')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s route="/logproto.Pusher/Push"}' % dashboards['vali-writes.json'].ingesterSelector)
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-writes.json'].matchers.ingester + [utils.selector.eq('route', '/logproto.Pusher/Push')],
          extra_selectors=dashboards['vali-writes.json'].clusterMatchers
        )
      )
    )
    .addRow(
      g.row('BigTable')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('cortex_bigtable_request_duration_seconds_count{%s operation="/google.bigtable.v2.Bigtable/MutateRows"}' % dashboards['vali-writes.json'].ingesterSelector)
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'cortex_bigtable_request_duration_seconds',
          dashboards['vali-writes.json'].clusterMatchers + dashboards['vali-writes.json'].matchers.ingester + [utils.selector.eq('operation', '/google.bigtable.v2.Bigtable/MutateRows')]
        )
      )
    )
    .addRow(
      g.row('BoltDB Shipper')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_boltdb_shipper_request_duration_seconds_count{%s operation="WRITE"}' % dashboards['vali-writes.json'].ingesterSelector)
      )
      .addPanel(
        g.panel('Latency') +
        g.latencyPanel('vali_boltdb_shipper_request_duration_seconds', '{%s operation="WRITE"}' % dashboards['vali-writes.json'].ingesterSelector)
      )
    ){
      templating+: {
        list+: [
          {
            allValue: null,
            current:
              if l.type == 'custom' then {
                text: l.query,
                value: l.query,
              } else {},
            datasource: '$datasource',
            hide: 0,
            includeAll: false,
            label: l.variable,
            multi: false,
            name: l.variable,
            options: [],
            query:
              if l.type == 'query' then
                'label_values(%s, %s)' % [l.query, l.label]
              else
                l.query,
            refresh: 1,
            regex: '',
            sort: 2,
            tagValuesQuery: '',
            tags: [],
            tagsQuery: '',
            type: l.type,
            useTags: false,
          }
          for l in dashboards['vali-writes.json'].templateLabels
        ],
      },
    },
  },
}
