## Strimzi Cluster Operator

The [Strimzi Cluster Operator](https://github.com/strimzi/strimzi-kafka-operator) is responsible for deploying and managing Kafka clusters within a Kubernetes cluster. \
When the Cluster Operator is running, it starts to watch for updates of Kafka Custom Schema Resouces.

When one of the kafka resources is created in the Kubernetes cluster, the operator gets the cluster description from the resource and starts creating it by deploying the necessary Kubernetes compenents, such as StatefulSets, Services and ConfigMaps.

Each time a Kafka resource is updated, the operator performs corresponding updates on the Kubernetes resources that make up the cluster for that resource.

When a resource is deleted, the operator undeploys the cluster and deletes all related Kubernetes resources.

### **Usage**

This module deploys the strimzi operator via the following [helm chart](https://github.com/strimzi/strimzi-kafka-operator/tree/main/helm-charts/helm3/strimzi-kafka-operator). \
Notice that through the Strimzi Cluster Operator all of Strimzi Custom resources like kafka, mirror-maker and so forth, are created from docker images tags that are decided by the operator.

For that reason, it's important to view the [releases](https://github.com/strimzi/strimzi-kafka-operator/releases), to find which kafka version Operator continues to support.

In the [strimzi_kafka module](../../../developers-main.tf), the following block can be added to change the strimzi operator [configurations](/terraform/modules/strimzi_operator/README.md):

```
strimzi_operator = {
    log_level = "value"
    replicas = 1
    ...
  }
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | >= 1.13.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.13.1 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.strimzi_kafka_operator](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubectl_manifest.crd_install](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |
| [random_uuid.example](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) | resource |
| [http_http.crd_yaml_file](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resources"></a> [resources](#input\_resources) | (Required) Resource requests/limit (CPU and Memory) to specify the maximum resources that can be consumed. | `map(string)` | n/a | yes |
| <a name="input_atomic"></a> [atomic](#input\_atomic) | (Optional) If set, installation process purges chart on fail. | `bool` | `true` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | (Optional) Allow deletion of new resources created in this upgrade when upgrade fails. | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | (Optional) Whether to create k8s namespace with name defined by `namespace` | `bool` | `true` | no |
| <a name="input_docker_registry"></a> [docker\_registry](#input\_docker\_registry) | (Optional) Docker image registry to pull the image from. | `string` | `"packages.af-eng.io/docker"` | no |
| <a name="input_feature_gates"></a> [feature\_gates](#input\_feature\_gates) | (Optional) Feature gates to enable on the cluster. | `string` | `"-"` | no |
| <a name="input_helm_chart_name"></a> [helm\_chart\_name](#input\_helm\_chart\_name) | (Optional) Helm chart name to be installed. | `string` | `"strimzi-kafka-operator"` | no |
| <a name="input_helm_chart_version"></a> [helm\_chart\_version](#input\_helm\_chart\_version) | (Optional) Version of the Helm chart. | `string` | `"0.41.0"` | no |
| <a name="input_helm_release_name"></a> [helm\_release\_name](#input\_helm\_release\_name) | (Optional) The name of the pods that will be created by the chart. | `string` | `"strimzi-kafka-operator"` | no |
| <a name="input_helm_repo_url"></a> [helm\_repo\_url](#input\_helm\_repo\_url) | (Optional) Repository URL where to locate the requested chart. | `string` | `"oci://quay.io/strimzi-helm/"` | no |
| <a name="input_log_level"></a> [log\_level](#input\_log\_level) | (Optional) log level value can be one of:<pre>[INFO, ERROR, WARN, TRACE, DEBUG, FATAL, OFF]</pre> | `string` | `"info"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (Optional) The namespace to install the release into. | `string` | `"strimzi-operator"` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | (Optional) The number of replicas of strimzi operator to create. | `number` | `3` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | (Optional) Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). | `number` | `300` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | (Optional) Will wait until all resources are in a ready state before marking the release as successful. | `bool` | `true` | no |
| <a name="input_watch_any_namespace"></a> [watch\_any\_namespace](#input\_watch\_any\_namespace) | (Optional) Enable Strimzi-Operator to watch all namespaces. | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespace"></a> [namespace](#output\_namespace) | The namespace the resources gets deployed on for monitoring. |
<!-- END_TF_DOCS -->
