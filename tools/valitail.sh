#!/bin/sh

INSTANCEID="${1:-}"
APIKEY="${2:-}"
INSTANCEURL="${3:-}"
NAMESPACE="${4:-default}"
CONTAINERROOT="${5:-/var/lib/docker}"
PARSER="${6:-- docker:}"
VERSION="${VALITAIL_VERSION:-2.1.0}"

if [ -z "$INSTANCEID" -o -z "$APIKEY" -o -z "$INSTANCEURL" -o -z "$NAMESPACE" -o -z "$CONTAINERROOT" -o -z "$PARSER" ]; then
    echo "usage: $0 <instanceId> <apiKey> <url> [<namespace>[<container_root_path>[<parser>]]]"
    exit 1
fi

TEMPLATE=$(cat <<'YAML'
apiVersion: v1
data:
  valitail.yml: |
    scrape_configs:
    - pipeline_stages:
      <parser>
      job_name: kubernetes-pods-name
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - source_labels:
        - __meta_kubernetes_pod_label_name
        target_label: __service__
      - source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: __host__
      - action: drop
        regex: ^$
        source_labels:
        - __service__
      - action: replace
        replacement: $1
        separator: /
        source_labels:
        - __meta_kubernetes_namespace
        - __service__
        target_label: job
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: instance
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_container_name
        target_label: container_name
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_uid
        - __meta_kubernetes_pod_container_name
        target_label: __path__
    - pipeline_stages:
      <parser>
      job_name: kubernetes-pods-app
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: drop
        regex: .+
        source_labels:
        - __meta_kubernetes_pod_label_name
      - source_labels:
        - __meta_kubernetes_pod_label_app
        target_label: __service__
      - source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: __host__
      - action: drop
        regex: ^$
        source_labels:
        - __service__
      - action: replace
        replacement: $1
        separator: /
        source_labels:
        - __meta_kubernetes_namespace
        - __service__
        target_label: job
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: instance
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_container_name
        target_label: container_name
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_uid
        - __meta_kubernetes_pod_container_name
        target_label: __path__
    - pipeline_stages:
      <parser>
      job_name: kubernetes-pods-direct-controllers
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: drop
        regex: .+
        separator: ''
        source_labels:
        - __meta_kubernetes_pod_label_name
        - __meta_kubernetes_pod_label_app
      - action: drop
        regex: ^([0-9a-z-.]+)(-[0-9a-f]{8,10})$
        source_labels:
        - __meta_kubernetes_pod_controller_name
      - source_labels:
        - __meta_kubernetes_pod_controller_name
        target_label: __service__
      - source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: __host__
      - action: drop
        regex: ^$
        source_labels:
        - __service__
      - action: replace
        replacement: $1
        separator: /
        source_labels:
        - __meta_kubernetes_namespace
        - __service__
        target_label: job
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: instance
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_container_name
        target_label: container_name
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_uid
        - __meta_kubernetes_pod_container_name
        target_label: __path__
    - pipeline_stages:
      <parser>
      job_name: kubernetes-pods-indirect-controller
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: drop
        regex: .+
        separator: ''
        source_labels:
        - __meta_kubernetes_pod_label_name
        - __meta_kubernetes_pod_label_app
      - action: keep
        regex: ^([0-9a-z-.]+)(-[0-9a-f]{8,10})$
        source_labels:
        - __meta_kubernetes_pod_controller_name
      - action: replace
        regex: ^([0-9a-z-.]+)(-[0-9a-f]{8,10})$
        source_labels:
        - __meta_kubernetes_pod_controller_name
        target_label: __service__
      - source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: __host__
      - action: drop
        regex: ^$
        source_labels:
        - __service__
      - action: replace
        replacement: $1
        separator: /
        source_labels:
        - __meta_kubernetes_namespace
        - __service__
        target_label: job
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: instance
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_container_name
        target_label: container_name
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_uid
        - __meta_kubernetes_pod_container_name
        target_label: __path__
    - pipeline_stages:
      <parser>
      job_name: kubernetes-pods-static
      kubernetes_sd_configs:
      - role: pod
      relabel_configs:
      - action: drop
        regex: ^$
        source_labels:
        - __meta_kubernetes_pod_annotation_kubernetes_io_config_mirror
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_label_component
        target_label: __service__
      - source_labels:
        - __meta_kubernetes_pod_node_name
        target_label: __host__
      - action: drop
        regex: ^$
        source_labels:
        - __service__
      - action: replace
        replacement: $1
        separator: /
        source_labels:
        - __meta_kubernetes_namespace
        - __service__
        target_label: job
      - action: replace
        source_labels:
        - __meta_kubernetes_namespace
        target_label: namespace
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_name
        target_label: instance
      - action: replace
        source_labels:
        - __meta_kubernetes_pod_container_name
        target_label: container_name
      - replacement: /var/log/pods/*$1/*.log
        separator: /
        source_labels:
        - __meta_kubernetes_pod_annotation_kubernetes_io_config_mirror
        - __meta_kubernetes_pod_container_name
        target_label: __path__

kind: ConfigMap
metadata:
  name: valitail
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: valitail
spec:
  minReadySeconds: 10
  selector:
    matchLabels:
      name: valitail
  template:
    metadata:
      labels:
        name: valitail
    spec:
      containers:
      - args:
        - -client.url=https://<instanceId>:<apiKey>@<instanceUrl>/api/prom/push
        - -config.file=/etc/valitail/valitail.yml
        env:
        - name: HOSTNAME
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        image: ghcr.io/credativ/valitail:<version>
        imagePullPolicy: Always
        name: valitail
        readinessProbe:
          httpGet:
            path: /ready
            port: http-metrics
            scheme: HTTP
          initialDelaySeconds: 10
        ports:
        - containerPort: 80
          name: http-metrics
        securityContext:
          privileged: true
          runAsUser: 0
        volumeMounts:
        - mountPath: /etc/valitail
          name: valitail
        - mountPath: /var/log
          name: varlog
        - mountPath: /var/lib/docker/containers
          name: varlibdockercontainers
          readOnly: true
      serviceAccount: valitail
      tolerations:
      - effect: NoSchedule
        operator: Exists
      volumes:
      - configMap:
          name: valitail
        name: valitail
      - hostPath:
          path: /var/log
        name: varlog
      - hostPath:
          path: <container_root_path>/containers
        name: varlibdockercontainers
  updateStrategy:
    type: RollingUpdate
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: valitail
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  name: valitail
rules:
- apiGroups:
  - ""
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs:
  - get
  - list
  - watch
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: valitail
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: valitail
subjects:
- kind: ServiceAccount
  name: valitail
  namespace: <namespace>
YAML
)

echo "$TEMPLATE" | sed \
  -e "s#<instanceId>#${INSTANCEID}#" \
  -e "s#<apiKey>#${APIKEY}#" \
  -e "s#<instanceUrl>#${INSTANCEURL}#" \
  -e "s#<namespace>#${NAMESPACE}#" \
  -e "s#<container_root_path>#${CONTAINERROOT}#" \
  -e "s#<parser>#${PARSER}#" \
  -e "s#<version>#${VERSION}#"
