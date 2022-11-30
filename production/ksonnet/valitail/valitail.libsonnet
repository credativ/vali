local scrape_config = import './scrape_config.libsonnet';
local config = import 'config.libsonnet';
local k = import 'ksonnet-util/kausal.libsonnet';

// backwards compatibility with ksonnet
local envVar = if std.objectHasAll(k.core.v1, 'envVar') then k.core.v1.envVar else k.core.v1.container.envType;

k + config + scrape_config {
  namespace:
    $.core.v1.namespace.new($._config.namespace),

  local policyRule = $.rbac.v1beta1.policyRule,

  valitail_rbac:
    $.util.rbac($._config.valitail_cluster_role_name, [
      policyRule.new() +
      policyRule.withApiGroups(['']) +
      policyRule.withResources(['nodes', 'nodes/proxy', 'services', 'endpoints', 'pods']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
    ]),

  valitail_config+:: {
    local service_url(client) =
      if std.objectHasAll(client, 'username') then
        '%(scheme)s://%(username)s:%(password)s@%(hostname)s/vali/api/v1/push' % client
      else
        '%(scheme)s://%(hostname)s/vali/api/v1/push' % client,

    local client_config(client) = client {
      url: service_url(client),
    },

    clients: std.map(client_config, $._config.valitail_config.clients),
  },

  local configMap = $.core.v1.configMap,

  valitail_config_map:
    configMap.new($._config.valitail_configmap_name) +
    configMap.withData({
      'valitail.yml': $.util.manifestYaml($.valitail_config),
    }),

  valitail_args:: {
    'config.file': '/etc/valitail/valitail.yml',
  },

  local container = $.core.v1.container,

  valitail_container::
    container.new('valitail', $._images.valitail) +
    container.withPorts($.core.v1.containerPort.new(name='http-metrics', port=80)) +
    container.withArgsMixin($.util.mapToFlags($.valitail_args)) +
    container.withEnv([
      envVar.fromFieldPath('HOSTNAME', 'spec.nodeName'),
    ]) +
    container.mixin.readinessProbe.httpGet.withPath('/ready') +
    container.mixin.readinessProbe.httpGet.withPort(80) +
    container.mixin.readinessProbe.withInitialDelaySeconds(10) +
    container.mixin.readinessProbe.withTimeoutSeconds(1) +
    container.mixin.securityContext.withPrivileged(true) +
    container.mixin.securityContext.withRunAsUser(0),

  local daemonSet = $.apps.v1.daemonSet,

  valitail_daemonset:
    daemonSet.new($._config.valitail_pod_name, [$.valitail_container]) +
    daemonSet.mixin.spec.template.spec.withServiceAccount($._config.valitail_cluster_role_name) +
    $.util.configMapVolumeMount($.valitail_config_map, '/etc/valitail') +
    $.util.hostVolumeMount('varlog', '/var/log', '/var/log') +
    $.util.hostVolumeMount('varlibdockercontainers', $._config.valitail_config.container_root_path + '/containers', $._config.valitail_config.container_root_path + '/containers', readOnly=true),
}
