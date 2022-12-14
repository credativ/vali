# Fluentd output plugin

[Fluentd](https://fluentd.org/) is a data collector for unified logging layer, it can be configured with the Vali output plugin, provided in this folder, to ship logs to Vali.

See [docs/client/fluentd/README.md](../../docs/sources/clients/fluentd/_index.md) for detailed information.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `fluent-plugin-plutono-vali.gemspec`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To create the gem: `gem build fluent-plugin-plutono-vali.gemspec`

Useful additions:
  `gem install rubocop`

## Testing

Start Vali using:

```bash
docker run -it -p 3100:3100 ghcr.io/credativ/vali:latest
```

Verify that Vali accept and stores logs:

```bash
curl -H "Content-Type: application/json" -XPOST -s "http://localhost:3100/vali/api/v1/push" --data-raw "{\"streams\": [{\"stream\": {\"job\": \"test\"}, \"values\": [[\"$(date +%s)000000000\", \"fizzbuzz\"]]}]}"
curl "http://localhost:3100/vali/api/v1/query_range" --data-urlencode 'query={job="test"}' --data-urlencode 'step=300' | jq .data.result
```

The expected output is:

```json
[
  {
    "stream": {
      "job": "test"
    },
    "values": [
      [
        "1588337198000000000",
        "fizzbuzz"
      ]
    ]
  }
]
```

Start and send test logs with Fluentd using:

```bash
VALI_URL=http://{{ IP }}:3100 make fluentd-test
```

Verify that syslogs are being feeded into Vali:

```bash
curl "http://localhost:3100/vali/api/v1/query_range" --data-urlencode 'query={job="fluentd"}' --data-urlencode 'step=300' | jq .data.result
```

The expected output is:

```json
[
  {
    "stream": {
      "job": "fluentd"
    },
    "values": [
      [
        "1588336950379591919",
        "log=\"May  1 14:42:30 ibuprofen avahi-daemon[859]: New relevant interface vethb503225.IPv6 for mDNS.\""
      ],
      ...
    ]
  }
]
```

## Copyright

* Copyright(c) 2018- Grafana Labs
* License
  * Apache License, Version 2.0
