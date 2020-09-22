package main

import (
	_ "k8s.io/api"
	_ "k8s.io/apiextensions-apiserver"
	_ "k8s.io/apimachinery/pkg/util/errors"
	_ "k8s.io/apiserver/pkg/util/feature"
	_ "k8s.io/cli-runtime/pkg/genericclioptions"
	_ "k8s.io/client-go/kubernetes/scheme"
	_ "k8s.io/cloud-provider"
	_ "k8s.io/component-base/version"
	_ "k8s.io/kube-aggregator"
	_ "k8s.io/kubectl/pkg/util"
	_ "k8s.io/kubernetes/pkg/util/env"
	_ "kmodules.xyz/client-go/core/v1"
	_ "kmodules.xyz/crd-schema-fuzz"
	_ "kmodules.xyz/custom-resources/apis/appcatalog"
	_ "kmodules.xyz/monitoring-agent-api/api/v1"
	_ "kmodules.xyz/objectstore-api/api/v1"
	_ "kmodules.xyz/offshoot-api/api/v1"
	_ "kmodules.xyz/openshift/apis/apps/v1"
	_ "kmodules.xyz/prober/api/v1"
	_ "kmodules.xyz/webhook-runtime/apis/workload/v1"
)

func main() {}
