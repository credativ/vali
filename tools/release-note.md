This is release `${CIRCLE_TAG}` of Vali.

### Notable changes:
:warning: **ADD RELEASE NOTES HERE** :warning:


### Installation:
The components of Vali are currently distributed in plain binary form and as Docker container images. Choose what fits your use-case best.

#### Docker container:
* https://github.com/credativ/vali/pkgs/container/vali
* https://github.com/credativ/vali/pkgs/container/valitail
```bash
$ docker pull "ghcr.io/credativ/vali:${CIRCLE_TAG}"
$ docker pull "ghcr.io/credativ/valitail:${CIRCLE_TAG}"
```

#### Binary
We provide pre-compiled binary executables for the most common operating systems and architectures.
Choose from the assets below for the application and architecture matching your system.
Example for `Vali` on the `linux` operating system and `amd64` architecture:

```bash
$ curl -O -L "https://github.com/credativ/vali/releases/download/${CIRCLE_TAG}/vali-linux-amd64.zip"
# extract the binary
$ unzip "vali-linux-amd64.zip"
# make sure it is executable
$ chmod a+x "vali-linux-amd64"
```
