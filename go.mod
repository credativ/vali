module github.com/credativ/vali

go 1.24.0

require (
	cloud.google.com/go/pubsub v1.3.1
	github.com/NYTimes/gziphandler v1.1.1
	github.com/aws/aws-lambda-go v1.17.0
	github.com/bmatcuk/doublestar v1.2.2
	github.com/c2h5oh/datasize v0.0.0-20200112174442-28bbd4740fee
	github.com/cespare/xxhash/v2 v2.1.1
	github.com/coreos/go-systemd v0.0.0-20191104093116-d3cd4ed1dbcf
	github.com/cortexproject/cortex v1.6.1-0.20210204145131-7dac81171c66
	github.com/davecgh/go-spew v1.1.1
	github.com/docker/docker v20.10.1+incompatible
	github.com/docker/go-plugins-helpers v0.0.0-20181025120712-1e6269c305b8
	github.com/drone/envsubst v1.0.2
	github.com/dustin/go-humanize v1.0.0
	github.com/fatih/color v1.9.0
	github.com/felixge/fgprof v0.9.1
	github.com/fluent/fluent-bit-go v0.0.0-20190925192703-ea13c021720c
	github.com/go-kit/kit v0.10.0
	github.com/go-logfmt/logfmt v0.5.0
	github.com/gogo/protobuf v1.3.1 // remember to update vali-build-image/Dockerfile too
	github.com/golang/snappy v0.0.3-0.20201103224600-674baa8c7fc3
	github.com/gorilla/mux v1.7.3
	github.com/gorilla/websocket v1.4.2
	github.com/grpc-ecosystem/go-grpc-middleware v1.1.0
	github.com/grpc-ecosystem/grpc-opentracing v0.0.0-20180507213350-8e809c8a8645
	github.com/hashicorp/golang-lru v0.5.4
	github.com/hpcloud/tail v1.0.0
	github.com/imdario/mergo v0.3.9
	github.com/influxdata/go-syslog/v3 v3.0.1-0.20200510134747-836dce2cf6da
	github.com/influxdata/telegraf v1.16.3
	github.com/jmespath/go-jmespath v0.4.0
	github.com/joncrlsn/dque v2.2.1-0.20200515025108-956d14155fa2+incompatible
	github.com/json-iterator/go v1.1.12
	github.com/klauspost/compress v1.11.3
	github.com/mitchellh/mapstructure v1.3.3
	github.com/modern-go/reflect2 v1.0.2
	github.com/mwitkow/go-conntrack v0.0.0-20190716064945-2f068394615f
	github.com/opentracing/opentracing-go v1.2.0
	// github.com/pierrec/lz4 v2.0.5+incompatible
	github.com/pierrec/lz4/v4 v4.1.1
	github.com/pkg/errors v0.9.1
	github.com/prometheus/client_golang v1.9.0
	github.com/prometheus/client_model v0.2.0
	github.com/prometheus/common v0.15.0
	github.com/prometheus/prometheus v1.8.2-0.20210124145330-b5dfa2414b9e
	github.com/segmentio/fasthash v1.0.2
	github.com/shurcooL/httpfs v0.0.0-20190707220628-8d4bc4ba7749
	github.com/shurcooL/vfsgen v0.0.0-20200824052919-0d455de96546
	github.com/spf13/afero v1.2.2
	github.com/stretchr/testify v1.6.1
	github.com/tonistiigi/fifo v0.0.0-20190226154929-a9fb20d87448
	github.com/uber/jaeger-client-go v2.25.0+incompatible
	github.com/weaveworks/common v0.0.0-20210112142934-23c8d7fa6120
	go.etcd.io/bbolt v1.3.5-0.20200615073812-232d8fc87f50
	go.uber.org/atomic v1.7.0
	golang.org/x/crypto v0.43.0
	golang.org/x/net v0.46.0
	golang.org/x/sys v0.37.0
	google.golang.org/api v0.36.0
	google.golang.org/grpc v1.76.0
	gopkg.in/alecthomas/kingpin.v2 v2.2.6
	gopkg.in/fsnotify.v1 v1.4.7
	gopkg.in/yaml.v2 v2.4.0
	gopkg.in/yaml.v3 v3.0.0-20200615113413-eeeca48fe776
	k8s.io/klog v1.0.0
)

require (
	cloud.google.com/go v0.72.0 // indirect
	cloud.google.com/go/bigquery v1.8.0 // indirect
	cloud.google.com/go/bigtable v1.2.0 // indirect
	cloud.google.com/go/datastore v1.1.0 // indirect
	cloud.google.com/go/storage v1.10.0 // indirect
	code.cloudfoundry.org/clock v1.0.0 // indirect
	collectd.org v0.3.0 // indirect
	contrib.go.opencensus.io/exporter/ocagent v0.6.0 // indirect
	dmitri.shuralyov.com/gpu/mtl v0.0.0-20190408044501-666a987793e9 // indirect
	github.com/Azure/azure-amqp-common-go/v3 v3.0.0 // indirect
	github.com/Azure/azure-event-hubs-go/v3 v3.2.0 // indirect
	github.com/Azure/azure-pipeline-go v0.2.2 // indirect
	github.com/Azure/azure-sdk-for-go v49.2.0+incompatible // indirect
	github.com/Azure/azure-storage-blob-go v0.8.0 // indirect
	github.com/Azure/azure-storage-queue-go v0.0.0-20181215014128-6ed74e755687 // indirect
	github.com/Azure/go-amqp v0.12.6 // indirect
	github.com/Azure/go-ansiterm v0.0.0-20170929234023-d6e3b3328b78 // indirect
	github.com/Azure/go-autorest v14.2.0+incompatible // indirect
	github.com/Azure/go-autorest/autorest v0.11.15 // indirect
	github.com/Azure/go-autorest/autorest/adal v0.9.10 // indirect
	github.com/Azure/go-autorest/autorest/azure/auth v0.4.2 // indirect
	github.com/Azure/go-autorest/autorest/azure/cli v0.3.1 // indirect
	github.com/Azure/go-autorest/autorest/date v0.3.0 // indirect
	github.com/Azure/go-autorest/autorest/mocks v0.4.1 // indirect
	github.com/Azure/go-autorest/autorest/to v0.3.1-0.20191028180845-3492b2aff503 // indirect
	github.com/Azure/go-autorest/autorest/validation v0.2.1-0.20191028180845-3492b2aff503 // indirect
	github.com/Azure/go-autorest/logger v0.2.0 // indirect
	github.com/Azure/go-autorest/tracing v0.6.0 // indirect
	github.com/BurntSushi/toml v0.3.1 // indirect
	github.com/BurntSushi/xgb v0.0.0-20160522181843-27f122750802 // indirect
	github.com/DATA-DOG/go-sqlmock v1.3.3 // indirect
	github.com/DataDog/datadog-go v3.2.0+incompatible // indirect
	github.com/HdrHistogram/hdrhistogram-go v0.9.0 // indirect
	github.com/Jeffail/gabs v1.1.0 // indirect
	github.com/Knetic/govaluate v3.0.1-0.20171022003610-9aa49832a739+incompatible // indirect
	github.com/Masterminds/squirrel v0.0.0-20161115235646-20f192218cf5 // indirect
	github.com/Mellanox/rdmamap v0.0.0-20191106181932-7c3c4763a6ee // indirect
	github.com/Microsoft/ApplicationInsights-Go v0.4.2 // indirect
	github.com/Microsoft/go-winio v0.4.14 // indirect
	github.com/Nvveen/Gotty v0.0.0-20120604004816-cd527374f1e5 // indirect
	github.com/OneOfOne/xxhash v1.2.6 // indirect
	github.com/PuerkitoBio/purell v1.1.1 // indirect
	github.com/PuerkitoBio/urlesc v0.0.0-20170810143723-de5bf2ad4578 // indirect
	github.com/SAP/go-hdb v0.12.0 // indirect
	github.com/SermoDigital/jose v0.0.0-20180104203859-803625baeddc // indirect
	github.com/Shopify/sarama v1.27.1 // indirect
	github.com/Shopify/toxiproxy v2.1.4+incompatible // indirect
	github.com/StackExchange/wmi v0.0.0-20180116203802-5d049714c4a6 // indirect
	github.com/VividCortex/gohistogram v1.0.0 // indirect
	github.com/abdullin/seq v0.0.0-20160510034733-d5467c17e7af // indirect
	github.com/aerospike/aerospike-client-go v1.27.0 // indirect
	github.com/afex/hystrix-go v0.0.0-20180502004556-fa1af6a1f4f5 // indirect
	github.com/agnivade/levenshtein v1.0.1 // indirect
	github.com/ajstarks/svgo v0.0.0-20180226025133-644b8db467af // indirect
	github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751 // indirect
	github.com/alecthomas/units v0.0.0-20201120081800-1786d5ef83d4 // indirect
	github.com/alicebob/gopher-json v0.0.0-20200520072559-a9ecdc9d1d3a // indirect
	github.com/alicebob/miniredis v2.5.0+incompatible // indirect
	github.com/aliyun/aliyun-oss-go-sdk v2.0.4+incompatible // indirect
	github.com/amir/raidman v0.0.0-20170415203553-1ccc43bfb9c9 // indirect
	github.com/andreyvit/diff v0.0.0-20170406064948-c7f18ee00883 // indirect
	github.com/antihax/optional v1.0.0 // indirect
	github.com/apache/arrow/go/arrow v0.0.0-20191024131854-af6fa24be0db // indirect
	github.com/apache/thrift v0.13.0 // indirect
	github.com/aristanetworks/glog v0.0.0-20191112221043-67e8567f59f3 // indirect
	github.com/aristanetworks/goarista v0.0.0-20190325233358-a123909ec740 // indirect
	github.com/armon/circbuf v0.0.0-20150827004946-bbbad097214e // indirect
	github.com/armon/go-metrics v0.3.6 // indirect
	github.com/armon/go-radix v1.0.0 // indirect
	github.com/armon/go-socks5 v0.0.0-20160902184237-e75332964ef5 // indirect
	github.com/aryann/difflib v0.0.0-20170710044230-e206f873d14a // indirect
	github.com/asaskevich/govalidator v0.0.0-20200907205600-7a23bdc65eef // indirect
	github.com/aws/aws-sdk-go v1.36.15 // indirect
	github.com/aws/aws-sdk-go-v2 v0.18.0 // indirect
	github.com/baiyubin/aliyun-sts-go-sdk v0.0.0-20180326062324-cfa1a18b161f // indirect
	github.com/beevik/ntp v0.2.0 // indirect
	github.com/benbjohnson/clock v1.0.3 // indirect
	github.com/beorn7/perks v1.0.1 // indirect
	github.com/bgentry/speakeasy v0.1.0 // indirect
	github.com/bitly/go-hostpool v0.1.0 // indirect
	github.com/blang/semver v3.5.0+incompatible // indirect
	github.com/bmizerany/assert v0.0.0-20160611221934-b7ed37b82869 // indirect
	github.com/bmizerany/pat v0.0.0-20170815010413-6226ea591a40 // indirect
	github.com/boltdb/bolt v1.3.1 // indirect
	github.com/bradfitz/gomemcache v0.0.0-20190913173617-a41fca850d0b // indirect
	github.com/c-bata/go-prompt v0.2.2 // indirect
	github.com/caio/go-tdigest v2.3.0+incompatible // indirect
	github.com/casbin/casbin/v2 v2.1.2 // indirect
	github.com/cenkalti/backoff v2.2.1+incompatible // indirect
	github.com/cenkalti/backoff/v4 v4.0.2 // indirect
	github.com/census-instrumentation/opencensus-proto v0.2.1 // indirect
	github.com/cespare/xxhash v1.1.0 // indirect
	github.com/chromedp/cdproto v0.0.0-20200424080200-0de008e41fa0 // indirect
	github.com/chromedp/chromedp v0.5.3 // indirect
	github.com/chzyer/logex v1.1.10 // indirect
	github.com/chzyer/readline v0.0.0-20180603132655-2972be24d48e // indirect
	github.com/chzyer/test v0.0.0-20180213035817-a1ea475d72b1 // indirect
	github.com/circonus-labs/circonus-gometrics v2.3.1+incompatible // indirect
	github.com/circonus-labs/circonusllhist v0.1.3 // indirect
	github.com/cisco-ie/nx-telemetry-proto v0.0.0-20190531143454-82441e232cf6 // indirect
	github.com/clbanning/x2j v0.0.0-20191024224557-825249438eec // indirect
	github.com/cncf/udpa/go v0.0.0-20191209042840-269d4d468f6f // indirect
	github.com/cockroachdb/apd v1.1.0 // indirect
	github.com/cockroachdb/cockroach-go v0.0.0-20181001143604-e0a95dfd547c // indirect
	github.com/cockroachdb/datadriven v0.0.0-20190809214429-80d97fb3cbaa // indirect
	github.com/codahale/hdrhistogram v0.0.0-20161010025455-3a0bb77429bd // indirect
	github.com/containerd/containerd v1.4.1 // indirect
	github.com/containerd/continuity v0.0.0-20181203112020-004b46473808 // indirect
	github.com/containerd/fifo v0.0.0-20190226154929-a9fb20d87448 // indirect
	github.com/coredns/coredns v1.1.2 // indirect
	github.com/coreos/go-semver v0.3.0 // indirect
	github.com/coreos/pkg v0.0.0-20180928190104-399ea9e2e55f // indirect
	github.com/couchbase/go-couchbase v0.0.0-20180501122049-16db1f1fe037 // indirect
	github.com/couchbase/gomemcached v0.0.0-20180502221210-0da75df14530 // indirect
	github.com/couchbase/goutils v0.0.0-20180530154633-e865a1461c8a // indirect
	github.com/cpuguy83/go-md2man/v2 v2.0.0-20190314233015-f79a8a8ca69d // indirect
	github.com/creack/pty v1.1.11 // indirect
	github.com/cznic/b v0.0.0-20180115125044-35e9bbe41f07 // indirect
	github.com/cznic/fileutil v0.0.0-20180108211300-6a051e75936f // indirect
	github.com/cznic/golex v0.0.0-20170803123110-4ab7c5e190e4 // indirect
	github.com/cznic/internal v0.0.0-20180608152220-f44710a21d00 // indirect
	github.com/cznic/lldb v1.1.0 // indirect
	github.com/cznic/mathutil v0.0.0-20180504122225-ca4c9f2c1369 // indirect
	github.com/cznic/ql v1.2.0 // indirect
	github.com/cznic/sortutil v0.0.0-20150617083342-4c7342852e65 // indirect
	github.com/cznic/strutil v0.0.0-20171016134553-529a34b1c186 // indirect
	github.com/cznic/zappy v0.0.0-20160723133515-2533cb5b45cc // indirect
	github.com/dave/jennifer v1.2.0 // indirect
	github.com/denisenkom/go-mssqldb v0.0.0-20190707035753-2be1aa521ff4 // indirect
	github.com/denverdino/aliyungo v0.0.0-20170926055100-d3308649c661 // indirect
	github.com/devigned/tab v0.1.1 // indirect
	github.com/dgrijalva/jwt-go v3.2.0+incompatible // indirect
	github.com/dgrijalva/jwt-go/v4 v4.0.0-preview1 // indirect
	github.com/dgryski/go-bitstream v0.0.0-20180413035011-3522498ce2c8 // indirect
	github.com/dgryski/go-rendezvous v0.0.0-20200823014737-9f7001d12a5f // indirect
	github.com/dgryski/go-sip13 v0.0.0-20200911182023-62edffca9245 // indirect
	github.com/dhui/dktest v0.3.0 // indirect
	github.com/digitalocean/godo v1.54.0 // indirect
	github.com/dimchansky/utfbom v1.1.0 // indirect
	github.com/docker/distribution v2.7.1+incompatible // indirect
	github.com/docker/go-connections v0.4.0 // indirect
	github.com/docker/go-metrics v0.0.0-20181218153428-b84716841b82 // indirect
	github.com/docker/go-units v0.4.0 // indirect
	github.com/docker/libnetwork v0.8.0-dev.2.0.20181012153825-d7b61745d166 // indirect
	github.com/docker/spdystream v0.0.0-20160310174837-449fdfce4d96 // indirect
	github.com/docopt/docopt-go v0.0.0-20180111231733-ee0de3bc6815 // indirect
	github.com/duosecurity/duo_api_golang v0.0.0-20190308151101-6c680f768e74 // indirect
	github.com/eapache/go-resiliency v1.2.0 // indirect
	github.com/eapache/go-xerial-snappy v0.0.0-20180814174437-776d5712da21 // indirect
	github.com/eapache/queue v1.1.0 // indirect
	github.com/eclipse/paho.mqtt.golang v1.2.0 // indirect
	github.com/edsrzf/mmap-go v1.0.0 // indirect
	github.com/elastic/go-sysinfo v1.1.1 // indirect
	github.com/elastic/go-windows v1.0.1 // indirect
	github.com/elazarl/go-bindata-assetfs v0.0.0-20160803192304-e1a2a7ec64b0 // indirect
	github.com/elazarl/goproxy v0.0.0-20180725130230-947c36da3153 // indirect
	github.com/ema/qdisc v0.0.0-20190904071900-b82c76788043 // indirect
	github.com/emicklei/go-restful v0.0.0-20170410110728-ff4f55a20633 // indirect
	github.com/envoyproxy/go-control-plane v0.9.4 // indirect
	github.com/envoyproxy/protoc-gen-validate v0.1.0 // indirect
	github.com/ericchiang/k8s v1.2.0 // indirect
	github.com/evanphx/json-patch v4.9.0+incompatible // indirect
	github.com/facette/natsort v0.0.0-20181210072756-2cd4dd1e2dcb // indirect
	github.com/fatih/structs v0.0.0-20180123065059-ebf56d35bba7 // indirect
	github.com/fatih/structtag v1.1.0 // indirect
	github.com/felixge/httpsnoop v1.0.1 // indirect
	github.com/fogleman/gg v1.2.1-0.20190220221249-0403632d5b90 // indirect
	github.com/form3tech-oss/jwt-go v3.2.2+incompatible // indirect
	github.com/fortytw2/leaktest v1.3.0 // indirect
	github.com/franela/goblin v0.0.0-20200105215937-c9ffbefa60db // indirect
	github.com/franela/goreq v0.0.0-20171204163338-bcd34c9993f8 // indirect
	github.com/frankban/quicktest v1.10.2 // indirect
	github.com/fsnotify/fsnotify v1.4.9 // indirect
	github.com/fsouza/fake-gcs-server v1.7.0 // indirect
	github.com/ghodss/yaml v1.0.1-0.20190212211648-25d852aebe32 // indirect
	github.com/glinton/ping v0.1.4-0.20200311211934-5ac87da8cd96 // indirect
	github.com/globalsign/mgo v0.0.0-20181015135952-eeefdecb41b8 // indirect
	github.com/glycerine/go-unsnap-stream v0.0.0-20180323001048-9f0cb55181dd // indirect
	github.com/glycerine/goconvey v0.0.0-20190410193231-58a59202ab31 // indirect
	github.com/go-gl/glfw v0.0.0-20190409004039-e6da0acd62b1 // indirect
	github.com/go-gl/glfw/v3.3/glfw v0.0.0-20200222043503-6f7a984d4dc4 // indirect
	github.com/go-ini/ini v1.25.4 // indirect
	github.com/go-ldap/ldap v3.0.2+incompatible // indirect
	github.com/go-logr/logr v0.2.0 // indirect
	github.com/go-ole/go-ole v1.2.1 // indirect
	github.com/go-openapi/analysis v0.19.10 // indirect
	github.com/go-openapi/errors v0.19.8 // indirect
	github.com/go-openapi/jsonpointer v0.19.3 // indirect
	github.com/go-openapi/jsonreference v0.19.3 // indirect
	github.com/go-openapi/loads v0.19.5 // indirect
	github.com/go-openapi/runtime v0.19.15 // indirect
	github.com/go-openapi/spec v0.19.8 // indirect
	github.com/go-openapi/strfmt v0.19.11 // indirect
	github.com/go-openapi/swag v0.19.9 // indirect
	github.com/go-openapi/validate v0.19.14 // indirect
	github.com/go-redis/redis v6.15.9+incompatible // indirect
	github.com/go-redis/redis/v8 v8.2.3 // indirect
	github.com/go-sql-driver/mysql v1.5.0 // indirect
	github.com/go-stack/stack v1.8.0 // indirect
	github.com/go-test/deep v1.0.1 // indirect
	github.com/gobuffalo/attrs v0.0.0-20190224210810-a9411de4debd // indirect
	github.com/gobuffalo/depgen v0.1.0 // indirect
	github.com/gobuffalo/envy v1.7.0 // indirect
	github.com/gobuffalo/flect v0.1.3 // indirect
	github.com/gobuffalo/genny v0.1.1 // indirect
	github.com/gobuffalo/gitgen v0.0.0-20190315122116-cc086187d211 // indirect
	github.com/gobuffalo/gogen v0.1.1 // indirect
	github.com/gobuffalo/logger v0.0.0-20190315122211-86e12af44bc2 // indirect
	github.com/gobuffalo/mapi v1.0.2 // indirect
	github.com/gobuffalo/packd v0.1.0 // indirect
	github.com/gobuffalo/packr/v2 v2.2.0 // indirect
	github.com/gobuffalo/syncx v0.0.0-20190224160051-33c29581e754 // indirect
	github.com/goburrow/modbus v0.1.0 // indirect
	github.com/goburrow/serial v0.1.0 // indirect
	github.com/gobwas/glob v0.2.3 // indirect
	github.com/gobwas/httphead v0.0.0-20180130184737-2c6c146eadee // indirect
	github.com/gobwas/pool v0.2.0 // indirect
	github.com/gobwas/ws v1.0.2 // indirect
	github.com/gocql/gocql v0.0.0-20200526081602-cd04bd7f22a7 // indirect
	github.com/godbus/dbus v0.0.0-20190402143921-271e53dc4968 // indirect
	github.com/gofrs/flock v0.7.1 // indirect
	github.com/gofrs/uuid v3.3.0+incompatible // indirect
	github.com/gogo/googleapis v1.1.0 // indirect
	github.com/gogo/status v1.0.3 // indirect
	github.com/golang-migrate/migrate/v4 v4.7.0 // indirect
	github.com/golang/freetype v0.0.0-20170609003504-e2365dfdc4a0 // indirect
	github.com/golang/geo v0.0.0-20190916061304-5b978397cfec // indirect
	github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b // indirect
	github.com/golang/groupcache v0.0.0-20200121045136-8c9f03a8e57e // indirect
	github.com/golang/lint v0.0.0-20180702182130-06c8688daad7 // indirect
	github.com/golang/mock v1.4.4 // indirect
	github.com/golang/protobuf v1.4.3 // indirect
	github.com/gomodule/redigo v2.0.0+incompatible // indirect
	github.com/google/btree v1.0.0 // indirect
	github.com/google/flatbuffers v1.11.0 // indirect
	github.com/google/go-cmp v0.6.0 // indirect
	github.com/google/go-github v17.0.0+incompatible // indirect
	github.com/google/go-github/v32 v32.1.0 // indirect
	github.com/google/go-querystring v1.0.0 // indirect
	github.com/google/gofuzz v1.1.0 // indirect
	github.com/google/martian v2.1.0+incompatible // indirect
	github.com/google/martian/v3 v3.1.0 // indirect
	github.com/google/pprof v0.0.0-20201218002935-b9804c9f04c2 // indirect
	github.com/google/renameio v0.1.0 // indirect
	github.com/google/uuid v1.1.2 // indirect
	github.com/googleapis/gax-go v2.0.2+incompatible // indirect
	github.com/googleapis/gax-go/v2 v2.0.5 // indirect
	github.com/googleapis/gnostic v0.4.1 // indirect
	github.com/gopcua/opcua v0.1.12 // indirect
	github.com/gophercloud/gophercloud v0.15.0 // indirect
	github.com/gopherjs/gopherjs v0.0.0-20191106031601-ce3c9ade29de // indirect
	github.com/gorilla/context v1.1.1 // indirect
	github.com/gotestyourself/gotestyourself v2.2.0+incompatible // indirect
	github.com/gregjones/httpcache v0.0.0-20180305231024-9cad4c3443a7 // indirect
	github.com/grpc-ecosystem/go-grpc-prometheus v1.2.1-0.20191002090509-6af20e3a5340 // indirect
	github.com/grpc-ecosystem/grpc-gateway v1.16.0 // indirect
	github.com/hailocab/go-hostpool v0.0.0-20160125115350-e80d13ce29ed // indirect
	github.com/harlow/kinesis-consumer v0.3.1-0.20181230152818-2f58b136fee0 // indirect
	github.com/hashicorp/consul v1.2.1 // indirect
	github.com/hashicorp/consul/api v1.8.1 // indirect
	github.com/hashicorp/consul/sdk v0.7.0 // indirect
	github.com/hashicorp/errwrap v1.0.0 // indirect
	github.com/hashicorp/go-bexpr v0.1.0 // indirect
	github.com/hashicorp/go-checkpoint v0.0.0-20171009173528-1545e56e46de // indirect
	github.com/hashicorp/go-cleanhttp v0.5.1 // indirect
	github.com/hashicorp/go-discover v0.0.0-20190403160810-22221edb15cd // indirect
	github.com/hashicorp/go-hclog v0.12.2 // indirect
	github.com/hashicorp/go-immutable-radix v1.2.0 // indirect
	github.com/hashicorp/go-memdb v0.0.0-20180223233045-1289e7fffe71 // indirect
	github.com/hashicorp/go-msgpack v0.5.5 // indirect
	github.com/hashicorp/go-multierror v1.1.0 // indirect
	github.com/hashicorp/go-plugin v0.0.0-20180331002553-e8d22c780116 // indirect
	github.com/hashicorp/go-retryablehttp v0.5.3 // indirect
	github.com/hashicorp/go-rootcerts v1.0.2 // indirect
	github.com/hashicorp/go-sockaddr v1.0.2 // indirect
	github.com/hashicorp/go-syslog v1.0.0 // indirect
	github.com/hashicorp/go-uuid v1.0.2 // indirect
	github.com/hashicorp/go-version v1.2.0 // indirect
	github.com/hashicorp/go.net v0.0.1 // indirect
	github.com/hashicorp/hcl v0.0.0-20180906183839-65a6292f0157 // indirect
	github.com/hashicorp/hil v0.0.0-20160711231837-1e86c6b523c5 // indirect
	github.com/hashicorp/logutils v1.0.0 // indirect
	github.com/hashicorp/mdns v1.0.1 // indirect
	github.com/hashicorp/memberlist v0.2.2 // indirect
	github.com/hashicorp/net-rpc-msgpackrpc v0.0.0-20151116020338-a14192a58a69 // indirect
	github.com/hashicorp/raft v1.0.1-0.20190409200437-d9fe23f7d472 // indirect
	github.com/hashicorp/raft-boltdb v0.0.0-20150201200839-d1e82c1ec3f1 // indirect
	github.com/hashicorp/serf v0.9.5 // indirect
	github.com/hashicorp/vault v0.10.3 // indirect
	github.com/hashicorp/vault-plugin-secrets-kv v0.0.0-20190318174639-195e0e9d07f1 // indirect
	github.com/hashicorp/vic v1.5.1-0.20190403131502-bbfe86ec9443 // indirect
	github.com/hashicorp/yamux v0.0.0-20181012175058-2f1d1f20f75d // indirect
	github.com/hetznercloud/hcloud-go v1.23.1 // indirect
	github.com/hodgesds/perf-utils v0.0.8 // indirect
	github.com/hudl/fargo v1.3.0 // indirect
	github.com/ianlancetaylor/demangle v0.0.0-20200824232613-28f6c0f3b639 // indirect
	github.com/inconshreveable/mousetrap v1.0.0 // indirect
	github.com/influxdata/flux v0.65.1 // indirect
	github.com/influxdata/go-syslog/v2 v2.0.1 // indirect
	github.com/influxdata/influxdb v1.8.3 // indirect
	github.com/influxdata/influxdb1-client v0.0.0-20191209144304-8bf82d3c094d // indirect
	github.com/influxdata/influxql v1.1.1-0.20200828144457-65d3ef77d385 // indirect
	github.com/influxdata/line-protocol v0.0.0-20180522152040-32c6aa80de5e // indirect
	github.com/influxdata/promql/v2 v2.12.0 // indirect
	github.com/influxdata/roaring v0.4.13-0.20180809181101-fc520f41fab6 // indirect
	github.com/influxdata/tail v1.0.1-0.20200707181643-03a791b270e4 // indirect
	github.com/influxdata/tdigest v0.0.0-20181121200506-bf2b5ad3c0a9 // indirect
	github.com/influxdata/toml v0.0.0-20190415235208-270119a8ce65 // indirect
	github.com/influxdata/usage-client v0.0.0-20160829180054-6d3895376368 // indirect
	github.com/influxdata/wlog v0.0.0-20160411224016-7c63b0a71ef8 // indirect
	github.com/jackc/fake v0.0.0-20150926172116-812a484cc733 // indirect
	github.com/jackc/pgx v3.6.0+incompatible // indirect
	github.com/jarcoal/httpmock v0.0.0-20180424175123-9c70cfe4a1da // indirect
	github.com/jcmturner/gofork v1.0.0 // indirect
	github.com/jefferai/jsonx v0.0.0-20160721235117-9cc31c3135ee // indirect
	github.com/jessevdk/go-flags v1.4.0 // indirect
	github.com/jmespath/go-jmespath/internal/testify v1.5.1 // indirect
	github.com/joeshaw/multierror v0.0.0-20140124173710-69b34d4ec901 // indirect
	github.com/joho/godotenv v1.3.0 // indirect
	github.com/jonboulle/clockwork v0.1.0 // indirect
	github.com/joyent/triton-go v0.0.0-20180628001255-830d2b111e62 // indirect
	github.com/jpillora/backoff v1.0.0 // indirect
	github.com/jsimonetti/rtnetlink v0.0.0-20200117123717-f846d4f6c1f4 // indirect
	github.com/jstemmer/go-junit-report v0.9.1 // indirect
	github.com/jsternberg/zap-logfmt v1.0.0 // indirect
	github.com/jtolds/gls v4.20.0+incompatible // indirect
	github.com/julienschmidt/httprouter v1.3.0 // indirect
	github.com/jung-kurt/gofpdf v1.0.3-0.20190309125859-24315acbbda5 // indirect
	github.com/jwilder/encoding v0.0.0-20170811194829-b4e1701a28ef // indirect
	github.com/kardianos/osext v0.0.0-20190222173326-2bc1f35cddc0 // indirect
	github.com/kardianos/service v1.0.0 // indirect
	github.com/karrick/godirwalk v1.16.1 // indirect
	github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51 // indirect
	github.com/keybase/go-crypto v0.0.0-20180614160407-5114a9a81e1b // indirect
	github.com/kisielk/errcheck v1.2.0 // indirect
	github.com/kisielk/gotool v1.0.0 // indirect
	github.com/klauspost/cpuid v1.3.1 // indirect
	github.com/klauspost/crc32 v0.0.0-20161016154125-cb6bfca970f6 // indirect
	github.com/klauspost/pgzip v1.0.2-0.20170402124221-0bf5dcad4ada // indirect
	github.com/knq/sysutil v0.0.0-20191005231841-15668db23d08 // indirect
	github.com/konsorten/go-windows-terminal-sequences v1.0.3 // indirect
	github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515 // indirect
	github.com/kr/pretty v0.2.1 // indirect
	github.com/kr/pty v1.1.5 // indirect
	github.com/kr/text v0.2.0 // indirect
	github.com/kshvakov/clickhouse v1.3.5 // indirect
	github.com/kubernetes/apimachinery v0.0.0-20190119020841-d41becfba9ee // indirect
	github.com/kylelemons/godebug v1.1.0 // indirect
	github.com/lann/builder v0.0.0-20180802200727-47ae307949d0 // indirect
	github.com/lann/ps v0.0.0-20150810152359-62de8c46ede0 // indirect
	github.com/leanovate/gopter v0.2.4 // indirect
	github.com/leesper/go_rng v0.0.0-20190531154944-a612b043e353 // indirect
	github.com/leodido/ragel-machinery v0.0.0-20181214104525-299bdde78165 // indirect
	github.com/lib/pq v1.3.0 // indirect
	github.com/lightstep/lightstep-tracer-common/golang/gogo v0.0.0-20190605223551-bc2310a04743 // indirect
	github.com/lightstep/lightstep-tracer-go v0.18.1 // indirect
	github.com/lovoo/gcloud-opentracing v0.3.0 // indirect
	github.com/lufia/iostat v1.1.0 // indirect
	github.com/lyft/protoc-gen-validate v0.0.0-20180911180927-64fcb82c878e // indirect
	github.com/mailru/easyjson v0.7.1 // indirect
	github.com/markbates/oncer v0.0.0-20181203154359-bf2de49a0be2 // indirect
	github.com/markbates/safe v1.0.1 // indirect
	github.com/mattn/go-colorable v0.1.6 // indirect
	github.com/mattn/go-ieproxy v0.0.0-20191113090002-7c0f6868bffe // indirect
	github.com/mattn/go-isatty v0.0.12 // indirect
	github.com/mattn/go-runewidth v0.0.6 // indirect
	github.com/mattn/go-sqlite3 v1.11.0 // indirect
	github.com/mattn/go-tty v0.0.0-20180907095812-13ff1204f104 // indirect
	github.com/mattn/go-xmlrpc v0.0.3 // indirect
	github.com/matttproud/golang_protobuf_extensions v1.0.1 // indirect
	github.com/mdlayher/apcupsd v0.0.0-20200608131503-2bf01da7bf1b // indirect
	github.com/mdlayher/genetlink v1.0.0 // indirect
	github.com/mdlayher/netlink v1.1.0 // indirect
	github.com/mdlayher/wifi v0.0.0-20190303161829-b1436901ddee // indirect
	github.com/mgutz/ansi v0.0.0-20170206155736-9520e82c474b // indirect
	github.com/miekg/dns v1.1.35 // indirect
	github.com/mikioh/ipaddr v0.0.0-20190404000644-d465c8ab6721 // indirect
	github.com/minio/md5-simd v1.1.0 // indirect
	github.com/minio/minio-go/v6 v6.0.56 // indirect
	github.com/minio/minio-go/v7 v7.0.2 // indirect
	github.com/minio/sha256-simd v0.1.1 // indirect
	github.com/mitchellh/cli v1.1.0 // indirect
	github.com/mitchellh/copystructure v0.0.0-20160804032330-cdac8253d00f // indirect
	github.com/mitchellh/go-homedir v1.1.0 // indirect
	github.com/mitchellh/go-testing-interface v1.0.0 // indirect
	github.com/mitchellh/go-wordwrap v1.0.0 // indirect
	github.com/mitchellh/gox v0.4.0 // indirect
	github.com/mitchellh/hashstructure v0.0.0-20170609045927-2bca23e0e452 // indirect
	github.com/mitchellh/iochan v1.0.0 // indirect
	github.com/mitchellh/reflectwalk v1.0.1 // indirect
	github.com/moby/term v0.0.0-20201216013528-df9cb8a40635 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/montanaflynn/stats v0.0.0-20171201202039-1bf9dbcd8cbe // indirect
	github.com/morikuni/aec v1.0.0 // indirect
	github.com/mozillazg/go-cos v0.13.0 // indirect
	github.com/mozillazg/go-httpheader v0.2.1 // indirect
	github.com/mschoch/smat v0.0.0-20160514031455-90eadee771ae // indirect
	github.com/multiplay/go-ts3 v1.0.0 // indirect
	github.com/munnerz/goautoneg v0.0.0-20120707110453-a547fc61f48d // indirect
	github.com/mxk/go-flowrate v0.0.0-20140419014527-cca7078d478f // indirect
	github.com/nakagami/firebirdsql v0.0.0-20190310045651-3c02a58cfed8 // indirect
	github.com/naoina/go-stringutil v0.1.0 // indirect
	github.com/nats-io/jwt v0.3.2 // indirect
	github.com/nats-io/nats-server/v2 v2.1.4 // indirect
	github.com/nats-io/nats.go v1.9.1 // indirect
	github.com/nats-io/nkeys v0.1.3 // indirect
	github.com/nats-io/nuid v1.0.1 // indirect
	github.com/ncw/swift v1.0.52 // indirect
	github.com/newrelic/newrelic-telemetry-sdk-go v0.2.0 // indirect
	github.com/nicolai86/scaleway-sdk v1.10.2-0.20180628010248-798f60e20bb2 // indirect
	github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e // indirect
	github.com/nsqio/go-nsq v1.0.7 // indirect
	github.com/nxadm/tail v1.4.4 // indirect
	github.com/oklog/oklog v0.3.2 // indirect
	github.com/oklog/run v1.1.0 // indirect
	github.com/oklog/ulid v1.3.1 // indirect
	github.com/olekukonko/tablewriter v0.0.2 // indirect
	github.com/onsi/ginkgo v1.14.1 // indirect
	github.com/onsi/gomega v1.10.2 // indirect
	github.com/op/go-logging v0.0.0-20160315200505-970db520ece7 // indirect
	github.com/openconfig/gnmi v0.0.0-20180912164834-33a1865c3029 // indirect
	github.com/opencontainers/go-digest v1.0.0 // indirect
	github.com/opencontainers/image-spec v1.0.1 // indirect
	github.com/opencontainers/runc v0.1.1 // indirect
	github.com/opentracing-contrib/go-grpc v0.0.0-20180928155321-4b5a12d3ff02 // indirect
	github.com/opentracing-contrib/go-observer v0.0.0-20170622124052-a52f23424492 // indirect
	github.com/opentracing-contrib/go-stdlib v1.0.0 // indirect
	github.com/opentracing/basictracer-go v1.0.0 // indirect
	github.com/openzipkin-contrib/zipkin-go-opentracing v0.4.5 // indirect
	github.com/openzipkin/zipkin-go v0.2.2 // indirect
	github.com/openzipkin/zipkin-go-opentracing v0.3.4 // indirect
	github.com/ory/dockertest v3.3.4+incompatible // indirect
	github.com/packethost/packngo v0.1.1-0.20180711074735-b9cb5096f54c // indirect
	github.com/pact-foundation/pact-go v1.0.4 // indirect
	github.com/pascaldekloe/goe v0.1.0 // indirect
	github.com/patrickmn/go-cache v0.0.0-20180527043350-9f6ff22cfff8 // indirect
	github.com/paulbellamy/ratecounter v0.2.0 // indirect
	github.com/pborman/uuid v1.2.0 // indirect
	github.com/pelletier/go-toml v1.7.0 // indirect
	github.com/performancecopilot/speed v3.0.0+incompatible // indirect
	github.com/peterbourgon/diskv v2.0.1+incompatible // indirect
	github.com/peterh/liner v1.0.1-0.20180619022028-8c1271fcf47f // indirect
	github.com/philhofer/fwd v1.0.0 // indirect
	github.com/pierrec/lz4 v2.5.2+incompatible // indirect
	github.com/pkg/profile v1.2.1 // indirect
	github.com/pkg/term v0.0.0-20180730021639-bffc007b7fd5 // indirect
	github.com/pmezard/go-difflib v1.0.0 // indirect
	github.com/posener/complete v1.2.3 // indirect
	github.com/prometheus/alertmanager v0.21.1-0.20201106142418-c39b78780054 // indirect
	github.com/prometheus/exporter-toolkit v0.5.1 // indirect
	github.com/prometheus/node_exporter v1.0.0-rc.0.0.20200428091818-01054558c289 // indirect
	github.com/prometheus/procfs v0.2.0 // indirect
	github.com/rafaeljusto/redigomock v0.0.0-20190202135759-257e089e14a1 // indirect
	github.com/rcrowley/go-metrics v0.0.0-20200313005456-10cdbea86bc0 // indirect
	github.com/remyoudompheng/bigfft v0.0.0-20200410134404-eec4a21b6bb0 // indirect
	github.com/renier/xmlrpc v0.0.0-20170708154548-ce4a1a486c03 // indirect
	github.com/retailnext/hllpp v1.0.1-0.20180308014038-101a6d2f8b52 // indirect
	github.com/rogpeppe/fastuuid v1.2.0 // indirect
	github.com/rogpeppe/go-internal v1.3.0 // indirect
	github.com/rs/cors v1.7.0 // indirect
	github.com/russross/blackfriday/v2 v2.0.1 // indirect
	github.com/ryanuber/columnize v2.1.0+incompatible // indirect
	github.com/ryanuber/go-glob v0.0.0-20170128012129-256dc444b735 // indirect
	github.com/safchain/ethtool v0.0.0-20200218184317-f459e2d13664 // indirect
	github.com/samuel/go-zookeeper v0.0.0-20201211165307-7117e9ea2414 // indirect
	github.com/santhosh-tekuri/jsonschema v1.2.4 // indirect
	github.com/satori/go.uuid v1.2.1-0.20181028125025-b2ce2384e17b // indirect
	github.com/sean-/seed v0.0.0-20170313163322-e2103e2c3529 // indirect
	github.com/segmentio/kafka-go v0.2.0 // indirect
	github.com/sercand/kuberesolver v2.4.0+incompatible // indirect
	github.com/sergi/go-diff v1.0.0 // indirect
	github.com/shirou/gopsutil v2.20.9+incompatible // indirect
	github.com/shirou/w32 v0.0.0-20160930032740-bb4de0191aa4 // indirect
	github.com/shopspring/decimal v0.0.0-20200105231215-408a2507e114 // indirect
	github.com/shurcooL/sanitized_anchor_name v1.0.0 // indirect
	github.com/siebenmann/go-kstat v0.0.0-20160321171754-d34789b79745 // indirect
	github.com/sirupsen/logrus v1.6.0 // indirect
	github.com/smartystreets/assertions v1.0.1 // indirect
	github.com/smartystreets/goconvey v1.6.4 // indirect
	github.com/softlayer/softlayer-go v0.0.0-20180806151055-260589d94c7d // indirect
	github.com/soheilhy/cmux v0.1.4 // indirect
	github.com/soniah/gosnmp v1.25.0 // indirect
	github.com/sony/gobreaker v0.4.1 // indirect
	github.com/soundcloud/go-runit v0.0.0-20150630195641-06ad41a06c4a // indirect
	github.com/spaolacci/murmur3 v1.1.0 // indirect
	github.com/spf13/cast v1.3.0 // indirect
	github.com/spf13/cobra v0.0.3 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
	github.com/streadway/amqp v0.0.0-20190827072141-edfb9018d271 // indirect
	github.com/streadway/handy v0.0.0-20190108123426-d5acb3125c2a // indirect
	github.com/stretchr/objx v0.2.0 // indirect
	github.com/tbrandon/mbserver v0.0.0-20170611213546-993e1772cc62 // indirect
	github.com/tedsuo/ifrit v0.0.0-20191009134036-9a97d0632f00 // indirect
	github.com/tent/http-link-go v0.0.0-20130702225549-ac974c61c2f9 // indirect
	github.com/thanos-io/thanos v0.13.1-0.20210204123931-82545cdd16fe // indirect
	github.com/tidwall/gjson v1.6.0 // indirect
	github.com/tidwall/match v1.0.1 // indirect
	github.com/tidwall/pretty v1.0.0 // indirect
	github.com/tinylib/msgp v1.0.2 // indirect
	github.com/tmc/grpc-websocket-proxy v0.0.0-20190109142713-0ad062ec5ee5 // indirect
	github.com/tv42/httpunix v0.0.0-20150427012821-b75d8614f926 // indirect
	github.com/uber/jaeger-lib v2.4.0+incompatible // indirect
	github.com/ugorji/go v1.1.7 // indirect
	github.com/ugorji/go/codec v1.1.7 // indirect
	github.com/urfave/cli v1.22.1 // indirect
	github.com/urfave/cli/v2 v2.1.1 // indirect
	github.com/vektah/gqlparser v1.1.2 // indirect
	github.com/vishvananda/netlink v0.0.0-20171020171820-b2de5d10e38e // indirect
	github.com/vishvananda/netns v0.0.0-20180720170159-13995c7128cc // indirect
	github.com/vjeantet/grok v1.0.0 // indirect
	github.com/vmware/govmomi v0.19.0 // indirect
	github.com/wavefronthq/wavefront-sdk-go v0.9.2 // indirect
	github.com/weaveworks/promrus v1.2.0 // indirect
	github.com/willf/bitset v1.1.3 // indirect
	github.com/wvanbergen/kafka v0.0.0-20171203153745-e2edea948ddf // indirect
	github.com/wvanbergen/kazoo-go v0.0.0-20180202103751-f72d8611297a // indirect
	github.com/xanzy/go-gitlab v0.15.0 // indirect
	github.com/xdg/scram v0.0.0-20180814205039-7eeb5667e42c // indirect
	github.com/xdg/stringprep v1.0.0 // indirect
	github.com/xiang90/probing v0.0.0-20190116061207-43a291ad63a2 // indirect
	github.com/xlab/treeprint v1.0.0 // indirect
	github.com/yuin/goldmark v1.4.13 // indirect
	github.com/yuin/gopher-lua v0.0.0-20200816102855-ee81675732da // indirect
	gitlab.com/nyarla/go-crypt v0.0.0-20160106005555-d9a5dc2b789b // indirect
	go.elastic.co/apm v1.5.0 // indirect
	go.elastic.co/apm/module/apmhttp v1.5.0 // indirect
	go.elastic.co/apm/module/apmot v1.5.0 // indirect
	go.elastic.co/fastjson v1.0.0 // indirect
	go.etcd.io/etcd v0.5.0-alpha.5.0.20200520232829-54ba9589114f // indirect
	go.mongodb.org/mongo-driver v1.4.3 // indirect
	go.opencensus.io v0.22.5 // indirect
	go.opentelemetry.io/otel v0.11.0 // indirect
	go.starlark.net v0.0.0-20200901195727-6e684ef5eeee // indirect
	go.uber.org/automaxprocs v1.2.0 // indirect
	go.uber.org/goleak v1.1.10 // indirect
	go.uber.org/multierr v1.5.0 // indirect
	go.uber.org/tools v0.0.0-20190618225709-2cfd321de3ee // indirect
	go.uber.org/zap v1.14.1 // indirect
	golang.org/x/exp v0.0.0-20200821190819-94841d0725da // indirect
	golang.org/x/image v0.0.0-20190802002840-cff245a6509b // indirect
	golang.org/x/lint v0.0.0-20200302205851-738671d3881b // indirect
	golang.org/x/mobile v0.0.0-20190719004257-d2bd2a29d028 // indirect
	golang.org/x/mod v0.28.0 // indirect
	golang.org/x/oauth2 v0.0.0-20201208152858-08078c50e5b5 // indirect
	golang.org/x/sync v0.17.0 // indirect
	golang.org/x/telemetry v0.0.0-20250908211612-aef8a434d053 // indirect
	golang.org/x/term v0.36.0 // indirect
	golang.org/x/text v0.30.0 // indirect
	golang.org/x/time v0.0.0-20201208040808-7e3f01d25324 // indirect
	golang.org/x/tools v0.37.0 // indirect
	golang.org/x/xerrors v0.0.0-20200804184101-5ec99f83aff1 // indirect
	golang.zx2c4.com/wireguard v0.0.20200121 // indirect
	golang.zx2c4.com/wireguard/wgctrl v0.0.0-20200205215550-e35592f146e4 // indirect
	gonum.org/v1/gonum v0.6.2 // indirect
	gonum.org/v1/netlib v0.0.0-20190313105609-8cb42192e0e0 // indirect
	gonum.org/v1/plot v0.0.0-20190515093506-e2840ee46a6b // indirect
	google.golang.org/appengine v1.6.7 // indirect
	google.golang.org/genproto v0.0.0-20201201144952-b05cb90ed32e // indirect
	google.golang.org/protobuf v1.25.0 // indirect
	gopkg.in/airbrake/gobrake.v2 v2.0.9 // indirect
	gopkg.in/asn1-ber.v1 v1.0.0-20181015200546-f715ec2f112d // indirect
	gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b // indirect
	gopkg.in/cheggaaa/pb.v1 v1.0.25 // indirect
	gopkg.in/errgo.v2 v2.1.0 // indirect
	gopkg.in/fatih/pool.v2 v2.0.0 // indirect
	gopkg.in/fsnotify/fsnotify.v1 v1.4.7 // indirect
	gopkg.in/gcfg.v1 v1.2.3 // indirect
	gopkg.in/gemnasium/logrus-airbrake-hook.v2 v2.1.2 // indirect
	gopkg.in/gorethink/gorethink.v3 v3.0.5 // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	gopkg.in/ini.v1 v1.57.0 // indirect
	gopkg.in/jcmturner/aescts.v1 v1.0.1 // indirect
	gopkg.in/jcmturner/dnsutils.v1 v1.0.1 // indirect
	gopkg.in/jcmturner/goidentity.v3 v3.0.0 // indirect
	gopkg.in/jcmturner/gokrb5.v7 v7.5.0 // indirect
	gopkg.in/jcmturner/rpc.v1 v1.1.0 // indirect
	gopkg.in/ldap.v3 v3.1.0 // indirect
	gopkg.in/mgo.v2 v2.0.0-20180705113604-9856a29383ce // indirect
	gopkg.in/olivere/elastic.v5 v5.0.70 // indirect
	gopkg.in/ory-am/dockertest.v3 v3.3.4 // indirect
	gopkg.in/resty.v1 v1.12.0 // indirect
	gopkg.in/square/go-jose.v2 v2.3.1 // indirect
	gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7 // indirect
	gopkg.in/warnings.v0 v0.1.2 // indirect
	gotest.tools v2.2.0+incompatible // indirect
	gotest.tools/v3 v3.0.3 // indirect
	honnef.co/go/netdb v0.0.0-20150201073656-a416d700ae39 // indirect
	honnef.co/go/tools v0.0.1-2020.1.4 // indirect
	howett.net/plist v0.0.0-20181124034731-591f970eefbb // indirect
	k8s.io/api v0.20.1 // indirect
	k8s.io/apimachinery v0.20.1 // indirect
	k8s.io/client-go v12.0.0+incompatible // indirect
	k8s.io/gengo v0.0.0-20200413195148-3a45101e95ac // indirect
	k8s.io/klog/v2 v2.4.0 // indirect
	k8s.io/kube-openapi v0.0.0-20201113171705-d219536bb9fd // indirect
	k8s.io/utils v0.0.0-20200729134348-d5654de09c73 // indirect
	modernc.org/httpfs v1.0.0 // indirect
	modernc.org/libc v1.3.1 // indirect
	modernc.org/mathutil v1.1.1 // indirect
	modernc.org/memory v1.0.1 // indirect
	modernc.org/sqlite v1.7.4 // indirect
	modernc.org/tcl v1.4.1 // indirect
	rsc.io/binaryregexp v0.2.0 // indirect
	rsc.io/pdf v0.1.1 // indirect
	rsc.io/quote/v3 v3.1.0 // indirect
	rsc.io/sampler v1.3.0 // indirect
	sigs.k8s.io/structured-merge-diff v0.0.0-20190525122527-15d366b2352e // indirect
	sigs.k8s.io/structured-merge-diff/v3 v3.0.0 // indirect
	sigs.k8s.io/structured-merge-diff/v4 v4.0.2 // indirect
	sigs.k8s.io/yaml v1.2.0 // indirect
	sourcegraph.com/sourcegraph/appdash v0.0.0-20190731080439-ebfcffb1b5c0 // indirect
)

replace github.com/hpcloud/tail => github.com/grafana/tail v0.0.0-20201004203643-7aa4e4a91f03

replace github.com/Azure/azure-sdk-for-go => github.com/Azure/azure-sdk-for-go v36.2.0+incompatible

// Keeping this same as Cortex to avoid dependency issues.
replace k8s.io/client-go => k8s.io/client-go v0.19.4

replace k8s.io/api => k8s.io/api v0.19.4

replace github.com/hashicorp/consul => github.com/hashicorp/consul v1.5.1

// >v1.2.0 has some conflict with prometheus/alertmanager. Hence prevent the upgrade till it's fixed.
replace github.com/satori/go.uuid => github.com/satori/go.uuid v1.2.0

// Use fork of gocql that has gokit logs and Prometheus metrics.
replace github.com/gocql/gocql => github.com/grafana/gocql v0.0.0-20200605141915-ba5dc39ece85

// Same as Cortex, we can't upgrade to grpc 1.30.0 until go.etcd.io/etcd will support it.
replace google.golang.org/grpc => google.golang.org/grpc v1.29.1

// Same as Cortex
// Using a 3rd-party branch for custom dialer - see https://github.com/bradfitz/gomemcache/pull/86
replace github.com/bradfitz/gomemcache => github.com/themihai/gomemcache v0.0.0-20180902122335-24332e2d58ab

// Fix errors like too many arguments in call to "github.com/go-openapi/errors".Required
//   have (string, string)
//   want (string, string, interface {})
replace github.com/go-openapi/errors => github.com/go-openapi/errors v0.19.4

replace github.com/go-openapi/validate => github.com/go-openapi/validate v0.19.8
