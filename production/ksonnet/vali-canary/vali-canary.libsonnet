local config = import 'config.libsonnet';
local k = import 'ksonnet-util/kausal.libsonnet';

// backwards compatibility with ksonnet
local envVar = if std.objectHasAll(k.core.v1, 'envVar') then k.core.v1.envVar else k.core.v1.container.envType;

k + config {
  namespace: $.core.v1.namespace.new($._config.namespace),

  local container = $.core.v1.container,

  vali_canary_args:: {
    labelvalue: '$(POD_NAME)',
  },

  vali_canary_container::
    container.new('vali-canary', $._images.vali_canary) +
    $.util.resourcesRequests('10m', '20Mi') +
    container.withPorts($.core.v1.containerPort.new(name='http-metrics', port=80)) +
    container.withArgsMixin($.util.mapToFlags($.vali_canary_args)) +
    container.withEnv([
      envVar.fromFieldPath('HOSTNAME', 'spec.nodeName'),
      envVar.fromFieldPath('POD_NAME', 'metadata.name'),
    ]),

  local daemonSet = $.apps.v1.daemonSet,

  vali_canary_daemonset:
    daemonSet.new('vali-canary', [$.vali_canary_container]),
}
