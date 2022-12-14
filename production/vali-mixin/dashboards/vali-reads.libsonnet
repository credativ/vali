local g = import 'plutono-builder/plutono.libsonnet';
local utils = import 'mixin-utils/utils.libsonnet';

{
  plutonoDashboards+: {
    local dashboards = self,

    local http_routes = 'vali_api_v1_series|api_prom_series|api_prom_query|api_prom_label|api_prom_label_name_values|vali_api_v1_query|vali_api_v1_query_range|vali_api_v1_labels|vali_api_v1_label_name_values',
    local grpc_routes = '/logproto.Querier/Query|/logproto.Querier/Label|/logproto.Querier/Series|/logproto.Querier/QuerySample|/logproto.Querier/GetChunkIDs',

    'vali-reads.json': {
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
        queryFrontend: [utils.selector.re('job', '($namespace)/query-frontend')],
        querier: [utils.selector.re('job', '($namespace)/querier')],
        ingester: [utils.selector.re('job', '($namespace)/ingester')],
      },

      local selector(matcherId) =
        local ms = (cfg.clusterMatchers + cfg.matchers[matcherId]);
        if std.length(ms) > 0 then
          std.join(',', ['%(label)s%(op)s"%(value)s"' % matcher for matcher in ms]) + ','
        else '',

      cortexGwSelector:: selector('cortexgateway'),
      queryFrontendSelector:: selector('queryFrontend'),
      querierSelector:: selector('querier'),
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
    g.dashboard('Vali / Reads')
    .addRow(
      g.row('Frontend (cortex_gw)')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s route=~"%s"}' % [dashboards['vali-reads.json'].cortexGwSelector, http_routes])
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-reads.json'].matchers.cortexgateway + [utils.selector.re('route', http_routes)],
          extra_selectors=dashboards['vali-reads.json'].clusterMatchers,
          sum_by=['route']
        )
      )
    )
    .addRow(
      g.row('Frontend (query-frontend)')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s route=~"%s"}' % [dashboards['vali-reads.json'].queryFrontendSelector, http_routes])
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-reads.json'].matchers.queryFrontend + [utils.selector.re('route', http_routes)],
          extra_selectors=dashboards['vali-reads.json'].clusterMatchers,
          sum_by=['route']
        )
      )
    )
    .addRow(
      g.row('Querier')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s route=~"%s"}' % [dashboards['vali-reads.json'].querierSelector, http_routes])
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-reads.json'].matchers.querier + [utils.selector.re('route', http_routes)],
          extra_selectors=dashboards['vali-reads.json'].clusterMatchers,
          sum_by=['route']
        )
      )
    )
    .addRow(
      g.row('Ingester')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_request_duration_seconds_count{%s route=~"%s"}' % [dashboards['vali-reads.json'].ingesterSelector, grpc_routes])
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'vali_request_duration_seconds',
          dashboards['vali-reads.json'].matchers.querier + [utils.selector.re('route', grpc_routes)],
          extra_selectors=dashboards['vali-reads.json'].clusterMatchers,
          sum_by=['route']
        )
      )
    )
    .addRow(
      g.row('BigTable')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('cortex_bigtable_request_duration_seconds_count{%s operation="/google.bigtable.v2.Bigtable/ReadRows"}' % dashboards['vali-reads.json'].querierSelector)
      )
      .addPanel(
        g.panel('Latency') +
        utils.latencyRecordingRulePanel(
          'cortex_bigtable_request_duration_seconds',
          dashboards['vali-reads.json'].matchers.querier + [utils.selector.eq('operation', '/google.bigtable.v2.Bigtable/ReadRows')]
        )
      )
    )
    .addRow(
      g.row('BoltDB Shipper')
      .addPanel(
        g.panel('QPS') +
        g.qpsPanel('vali_boltdb_shipper_request_duration_seconds_count{%s operation="QUERY"}' % dashboards['vali-reads.json'].querierSelector)
      )
      .addPanel(
        g.panel('Latency') +
        g.latencyPanel('vali_boltdb_shipper_request_duration_seconds', '{%s operation="QUERY"}' % dashboards['vali-reads.json'].querierSelector)
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
          for l in dashboards['vali-reads.json'].templateLabels
        ],
      },
    },
  },
}
