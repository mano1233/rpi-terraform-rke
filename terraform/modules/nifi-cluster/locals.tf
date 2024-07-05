locals {
  crd_path = "https://raw.githubusercontent.com/konpyutaika/nifikop/v${var.helm_chart_version}-release/helm/nifikop/crds/"
  crds_names = [
    "nifi.konpyutaika.com_nificlusters.yaml",
    "nifi.konpyutaika.com_nificonnections.yaml",
    "nifi.konpyutaika.com_nifidataflows.yaml",
    "nifi.konpyutaika.com_nifinodegroupautoscalers.yaml",
    "nifi.konpyutaika.com_nifiparametercontexts.yaml",
    "nifi.konpyutaika.com_nifiregistryclients.yaml",
    "nifi.konpyutaika.com_nifiusergroups.yaml",
    "nifi.konpyutaika.com_nifiusers.yaml"
  ]
  crd_urls = [for yaml_name in local.crds_names : "${local.crd_path}${yaml_name}"]

}