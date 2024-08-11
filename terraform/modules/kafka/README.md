# Kafka Module

This module creates the Kafka configuration part of the whole kafka cluster deployment yaml.
This configuration part is later combined with all other Strimzi Kafka cluster resources via the "[kafka_zookeeper](/terraform/module_main.tf)" resource.

The following are configured:

1. Kafka version.
2. Kafka allocated resources (CPU and Memory) + JMX options.
3. Kafka Network configuration.
4. Storage Configuration.
5. Monitoring Configuration.

### **Kafka Version**

Check under Strimzi Kafka [releases](https://github.com/strimzi/strimzi-kafka-operator/releases) which Kafka versions are supported

### **Allocated Resources**

Read further on [Kubernetes Allocated Resources](/docs/Kubernetes_allocated_resources.md).

### **Network Configurations**

Strimzi comes with two types of network setup:

- Internal Network
- External Network

**Internal Network** is a type of network configured inside the kubernetes cluster. It is the network that allows pods to communicate inside the kubernetes through their application ports, regardless of the external network the kubernetes cluster sits on.

Pods that connect to the Kafka cluster in the kubernetes, like canary, lag-exporter, redpanda-console etc, can request the kafka cluster from this type of network.

**External Network** is a type of network that configured to be accessed externally, outside the kubernetes cluster.

Clients like Producers and Consumers, who don't run inside the kubernetes cluster, will access the cluster through this type of network. Via the [Kafka Discovery service](/docs/kafka-networking.md).

### **Storage Configurations**

The strimzi deployment runs our pods on a persistence local NVME storage on each EKS worker node for high preformance storage speed in terms of our Kafka brokers pods.

This is done with the help of [Static Local Storage Provisioner](/terraform/modules/local_path_provisioner/README.md).

### **Monitoring Configurations**

Strimzi have a build in JMX exporter for each Custom resource inside the Kafka Cluster Deployment (Kafka, Zookeeper, Entity Operator etc). \
That scrap data about each pod's inner doing, for Kafka it extracts the amount of data that goes inside the pod, and kafka application state.

These data can later be taken through our datadog integration, as well inside our build in promethoues stack module.
Both can be easily viewed through a [Datadog Dashboard](https://app.datadoghq.eu/dashboard/qpd-pn7-c45/kafka-cluster?from_ts=1666597587767&to_ts=1666597887767&live=true), as well as a [Grafana Dashboard](/terraform/modules/prometheous_stack/README.md).

### **Usage**

In the strimzi_kafka module the following block can be added to change the Kafka [configurations](/terraform/modules/kafka/README.md):

```
kafka = {
    brokers = 3
    kafka_config = {
      "offsets.topic.replication.factor" = "3"
    }
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
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | >= 1.13.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubectl_manifest.kafka_nodepool](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_affinity"></a> [affinity](#input\_affinity) | (Required) Affinity labels that are used on dedicated Kafka nodes. | <pre>list(object({<br>    key      = optional(string)<br>    operator = optional(string, "In")<br>    values   = optional(list(string))<br>  }))</pre> | n/a | yes |
| <a name="input_configmap_key"></a> [configmap\_key](#input\_configmap\_key) | (Required) ConfigMap deployment key that holds Kafka Metrics | `string` | n/a | yes |
| <a name="input_configmap_name"></a> [configmap\_name](#input\_configmap\_name) | (Required) ConfigMap deployment name that holds Kafka Metrics | `string` | n/a | yes |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | (Required) AWS route53 hosted zone name where the brokers records will get created to | `string` | n/a | yes |
| <a name="input_jvm"></a> [jvm](#input\_jvm) | (Required) Confiuration of JVM options for maximum and minimum memory allocation:<br>  -Xms = Minimum initial allocation heap size when the JVM starts.<br>  -Xmx = Maximum heap size. | `map(string)` | n/a | yes |
| <a name="input_kafka_cluster_name"></a> [kafka\_cluster\_name](#input\_kafka\_cluster\_name) | (Required) The name that will be given to the kafka cluster. | `string` | n/a | yes |
| <a name="input_resources"></a> [resources](#input\_resources) | (Required) Resource requests/limit (CPU and Memory) to specify the maximum resources that can be consumed. | `map(string)` | n/a | yes |
| <a name="input_storage"></a> [storage](#input\_storage) | (Required) Kafka Brokers persistence storage configuration | `map(string)` | n/a | yes |
| <a name="input_tolerations"></a> [tolerations](#input\_tolerations) | (Required) tolerations that are used on dedicated Kafka nodes. | <pre>list(object({<br>    key      = optional(string)<br>    operator = optional(string, "Equal")<br>    value    = optional(string)<br>    effect   = optional(string, "NoSchedule")<br>  }))</pre> | n/a | yes |
| <a name="input_zones"></a> [zones](#input\_zones) | (Required) Availability zones to distribute evenly between the brokers. | `list(string)` | n/a | yes |
| <a name="input_bootstrap_node_port"></a> [bootstrap\_node\_port](#input\_bootstrap\_node\_port) | (Optional) The max port available to use starting range from 32100. | `number` | `32300` | no |
| <a name="input_brokers"></a> [brokers](#input\_brokers) | (Optional) Number of Kafka brokers to create. | `number` | `3` | no |
| <a name="input_kafka_config"></a> [kafka\_config](#input\_kafka\_config) | (Optional) Additional Kafka base configuration. | `map(string)` | <pre>{<br>  "auto.create.topics.enable": "false",<br>  "auto.leader.rebalance.enable": "false",<br>  "client.quota.callback.class": "io.strimzi.kafka.quotas.StaticQuotaCallback",<br>  "client.quota.callback.static.storage.check-interval": "600",<br>  "controlled.shutdown.enable": "true",<br>  "default.replication.factor": "3",<br>  "delete.topic.enable": "true",<br>  "group.initial.rebalance.delay.ms": "6000",<br>  "log.flush.scheduler.interval.ms": "2000",<br>  "log.retention.hours": "24",<br>  "message.timestamp.type": "LogAppendTime",<br>  "min.insync.replicas": "1",<br>  "num.network.threads": "4",<br>  "num.recovery.threads.per.data.dir": "2",<br>  "num.replica.fetchers": "4",<br>  "offsets.topic.replication.factor": "3",<br>  "replica.selector.class": "org.apache.kafka.common.replica.RackAwareReplicaSelector",<br>  "socket.receive.buffer.bytes": "1048576",<br>  "socket.request.max.bytes": "104857600",<br>  "socket.send.buffer.bytes": "1048576",<br>  "transaction.state.log.min.isr": "1",<br>  "transaction.state.log.replication.factor": "3"<br>}</pre> | no |
| <a name="input_kafka_version"></a> [kafka\_version](#input\_kafka\_version) | (Optional) The Kafka version. | `string` | `"3.6.0"` | no |
| <a name="input_listener_tls"></a> [listener\_tls](#input\_listener\_tls) | (Optional) Wehter to activate tls on a specific listenter. | `map(string)` | <pre>{<br>  "external_tls_enabled": "true",<br>  "internal_tls_enabled": "true"<br>}</pre> | no |
| <a name="input_pod_annotations"></a> [pod\_annotations](#input\_pod\_annotations) | (Optional) Attached annotations to the Kafka pods | `map(string)` | <pre>{<br>  "karpenter.sh/do-not-disrupt": "true"<br>}</pre> | no |
| <a name="input_ports"></a> [ports](#input\_ports) | (Optional) Ports to be used by the Kafka brokers internal and external network. | `map(string)` | <pre>{<br>  "external_port": 9094,<br>  "internal_port": 9092<br>}</pre> | no |
| <a name="input_root_log_level"></a> [root\_log\_level](#input\_root\_log\_level) | (Optional) log level value must be one of:<pre>[INFO, ERROR, WARN, TRACE, DEBUG, FATAL, OFF]</pre> | `string` | `"INFO"` | no |
| <a name="input_service_annotations"></a> [service\_annotations](#input\_service\_annotations) | (Optional) Attached annotations to the Kafka External Bootsrap Service | `map(string)` | <pre>{<br>  "consul.hashicorp.com/service-sync": "true"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_number_of_brokers"></a> [number\_of\_brokers](#output\_number\_of\_brokers) | n/a |
| <a name="output_ports"></a> [ports](#output\_ports) | n/a |
| <a name="output_template"></a> [template](#output\_template) | n/a |
<!-- END_TF_DOCS -->
