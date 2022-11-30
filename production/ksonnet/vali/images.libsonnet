{
  _images+:: {
    // Various third-party images.
    memcached: 'memcached:1.5.17-alpine',
    memcachedExporter: 'prom/memcached-exporter:v0.6.0',

    vali: 'ghcr.io/credativ/vali:2.1.0',

    distributor: self.vali,
    ingester: self.vali,
    querier: self.vali,
    tableManager: self.vali,
    query_frontend: self.vali,
    ruler: self.vali,
    compactor: self.vali,
  },
}
