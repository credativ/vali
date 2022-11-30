## Debug images

To build debug images run

```shell
make debug
```

You can use the `docker-compose.yaml` in this directory to launch the debug versions of the image in docker


## Valitail in kubernetes

If you want to debug Valitail in kubernetes, I have done so with the ksonnet setup:

```shell
ks init valitail
cd valitail
ks env add valitail
jb init
jb install github.com/credativ/vali/production/ksonnet/valitail
vi environments/valitail/main.jsonnet
```

Replace the contents with:

```jsonnet
local valitail = import 'valitail/valitail.libsonnet';


valitail + {
  _images+:: {
    valitail: 'ghcr.io/credativ/valitail-debug:latest',
  },
  _config+:: {
    namespace: 'default',

    valitail_config+: {
      external_labels+: {
        cluster: 'some_cluster_name',
      },
      scheme: 'https',
      hostname: 'hostname',
      username: 'username',
      password: 'password',
    },
  },
}
```

change the `some_cluster_name` to anything meaningful to help find your logs in Vali

also update the `hostname`, `username`, and `password` for your Vali instance.

## Vali in kubernetes

Haven't tried this yet, it works from docker-compose so it should run in kubernetes just fine also.
