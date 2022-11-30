{
  _images+:: {
    valitail: 'ghcr.io/credativ/valitail:2.1.0',
  },

  _config+:: {
    prometheus_insecure_skip_verify: false,
    valitail_config: {
      clients: [{
        username:: '',
        password:: '',
        scheme:: 'https',
        hostname:: error 'must define a valid hostname',
        external_labels: {},
      }],
      container_root_path: '/var/lib/docker',
      pipeline_stages: [{
        docker: {},
      }],
    },
    valitail_cluster_role_name: 'valitail',
    valitail_configmap_name: 'valitail',
    valitail_pod_name: 'valitail',
  },
}
