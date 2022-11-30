#!/bin/bash

# sed-wrap runs the appropriate sed command based on the
# underlying value of $OSTYPE
sed-wrap() {
  if [[ "$OSTYPE" == "linux"* ]]; then
    # Linux
    sed -i "$1" $2
  else
    # macOS, BSD
    sed -i '' "$1" $2
  fi
}

echo
echo "Last 5 tags:"
git tag --sort=-taggerdate | head -n 5
echo

read -p "Enter release version: " VERSION

if [[ ${VERSION} =~ ^v[0-9]+\.[0-9]+\.[0-9]+.*$ ]]; then
    echo "New Version: ${VERSION}"
else
    echo "Version must be in the format v0.1.0"
    exit 1
fi

VALI_CURRENT=$(sed -n -e 's/^version: //p' production/helm/vali/Chart.yaml)
VALI_SUGGESTED=$(tools/increment_version.sh -m ${VALI_CURRENT})
VALITAIL_CURRENT=$(sed -n -e 's/^version: //p' production/helm/valitail/Chart.yaml)
VALITAIL_SUGGESTED=$(tools/increment_version.sh -m ${VALITAIL_CURRENT})
VALI_STACK_CURRENT=$(sed -n -e 's/^version: //p' production/helm/vali-stack/Chart.yaml)
VALI_STACK_SUGGESTED=$(tools/increment_version.sh -m ${VALI_STACK_CURRENT})
echo
echo "Current Vali helm chart version: ${VALI_CURRENT}"
read -p "Enter new Vali helm chart version [${VALI_SUGGESTED}]: " VALI_VERSION
VALI_VERSION=${VALI_VERSION:-${VALI_SUGGESTED}}
echo
echo "Current Valitail helm chart version: ${VALITAIL_CURRENT}"
read -p "Enter new Valitail helm chart version [${VALITAIL_SUGGESTED}]: " VALITAIL_VERSION
VALITAIL_VERSION=${VALITAIL_VERSION:-${VALITAIL_SUGGESTED}}
echo
echo "Current Vali-Stack helm chart version: ${VALI_STACK_CURRENT}"
read -p "Enter new Vali-Stack helm chart version [${VALI_STACK_SUGGESTED}]: " VALI_STACK_VERSION
VALI_STACK_VERSION=${VALI_STACK_VERSION:-${VALI_STACK_SUGGESTED}}
echo

echo "Creating Release"
echo "Release Version:       ${VERSION}"
echo "Vali Helm Chart:       ${VALI_VERSION}"
echo "Valitail Helm Chart:   ${VALITAIL_VERSION}"
echo "Vali-Stack Helm Chart: ${VALI_STACK_VERSION}"
echo
read -p "Is this correct? [y]: " CONTINUE
CONTINUE=${CONTINUE:-y}
echo

if [[ "${CONTINUE}" != "y" ]]; then
 exit 1
fi

echo "Updating helm and ksonnet image versions"
sed-wrap "s/.*valitail:.*/    valitail: 'grafana\/valitail:${VERSION}',/" production/ksonnet/valitail/config.libsonnet
sed-wrap "s/.*vali_canary:.*/    vali_canary: 'grafana\/vali-canary:${VERSION}',/" production/ksonnet/vali-canary/config.libsonnet
sed-wrap "s/.*vali:.*/    vali: 'grafana\/vali:${VERSION}',/" production/ksonnet/vali/images.libsonnet
sed-wrap "s/.*tag:.*/  tag: ${VERSION}/" production/helm/vali/values.yaml
sed-wrap "s/.*tag:.*/  tag: ${VERSION}/" production/helm/valitail/values.yaml

echo "Updating helm charts"
sed-wrap "s/^version:.*/version: ${VALI_VERSION}/" production/helm/vali/Chart.yaml
sed-wrap "s/^version:.*/version: ${VALITAIL_VERSION}/" production/helm/valitail/Chart.yaml
sed-wrap "s/^version:.*/version: ${VALI_STACK_VERSION}/" production/helm/vali-stack/Chart.yaml

sed-wrap "s/^appVersion:.*/appVersion: ${VERSION}/" production/helm/vali/Chart.yaml
sed-wrap "s/^appVersion:.*/appVersion: ${VERSION}/" production/helm/valitail/Chart.yaml
sed-wrap "s/^appVersion:.*/appVersion: ${VERSION}/" production/helm/vali-stack/Chart.yaml

echo
echo "######################################################################################################"
echo
echo "Version numbers updated, create a new branch, commit and push"
echo
echo "######################################################################################################"

