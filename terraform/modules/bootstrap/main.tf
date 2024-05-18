
resource "null_resource" "raspberry_pi_bootstrap" {
  # increment version here if you wish this to run again after running it the first time
  triggers = {
    version = "0.1.3"
  }
  for_each = var.nodes
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.private_key
    host        = each.value.ip_addr
  }

  # for use with Ubuntu 20.10 for RPi 3 or 4 (arm64 only)
  provisioner "file" {
    destination = "./hosts"
    content = templatefile("${path.module}/templates/hosts.tfpl", {
      hostname = each.value.hostname
      nodes    = var.nodes
    })
  }

  provisioner "file" {
    source      = "files/daemon.json"
    destination = "./daemon.json"
  }
  # for use with Ubuntu 20.10 for RPi 3 or 4 (arm64 only)
  provisioner "remote-exec" {
    inline = [
      # system & package updates - then lock kernel updates
      "sudo apt-get update -y",
      "sudo apt-get -o Dpkg::Options::='--force-confnew' upgrade -y",
      "sleep 5",
      "sudo apt-get -o Dpkg::Options::='--force-confnew' dist-upgrade -y",
      "sleep 5",
      "sudo apt --fix-broken install -y",
      "sudo apt-mark hold linux-raspi",
      "sudo apt-get -y --purge autoremove",

      # install docker for arm64 (only have focal version right now)
      # for now rancher rke requires a version of docker just little further behind
      "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common ",
      "echo 'deb [arch=arm64] https://download.docker.com/linux/ubuntu focal stable' | sudo tee /etc/apt/sources.list.d/docker.list",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add",
      "sudo apt-get update -y",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io",
      # rke may want a specific Docker version, or in the cluster.tf you can disable the Docker version check
      #"sudo apt-get install -y docker-ce=5:19.03.14~3-0~ubuntu-focal docker-ce-cli=5:19.03.14~3-0~ubuntu-focal containerd.io",

      # replace the contents of /etc/docker/daemon.json to enable the systemd cgroup driver
      "sudo rm -f /etc/docker/daemon.json",
      "cat ~/daemon.json | sudo tee /etc/docker/daemon.json",
      "rm -f ~/daemon.json",
      "sudo systemctl enable --now docker",

      "sudo rm -f /etc/hosts",
      "cat ~/hosts | sudo tee /etc/hosts",
      "rm -f ~/daemon.json",

      # check each kernel command line option and append if necessary
      "if ! grep -qP 'cgroup_enable=cpuset' /boot/firmware/cmdline.txt; then sudo sed -i.bck '$s/$/ cgroup_enable=cpuset/' /boot/firmware/cmdline.txt; fi",
      "if ! grep -qP 'cgroup_enable=memory' /boot/firmware/cmdline.txt; then sudo sed -i.bck '$s/$/ cgroup_enable=memory/' /boot/firmware/cmdline.txt; fi",
      "if ! grep -qP 'cgroup_memory=1' /boot/firmware/cmdline.txt; then sudo sed -i.bck '$s/$/ cgroup_memory=1/' /boot/firmware/cmdline.txt; fi",
      "if ! grep -qP 'swapaccount=1' /boot/firmware/cmdline.txt; then sudo sed -i.bck '$s/$/ swapaccount=1/' /boot/firmware/cmdline.txt; fi",

      # allow iptables to see bridged traffic
      "echo 'net.bridge.bridge-nf-call-ip6tables = 1' >> ./k8s.conf",
      "echo 'net.bridge.bridge-nf-call-iptables = 1' >> ./k8s.conf",
      "cat ./k8s.conf | sudo tee /etc/sysctl.d/k8s.conf",
      "rm -f ./k8s.conf",
      "sudo sysctl --system",

      # reboot to confirm the changes are persistent
      "sudo shutdown -r +0"
    ]
  }
}

# wait 90 seconds after the node(s) have rebooted before doing anything else
resource "time_sleep" "wait_90_seconds" {
  depends_on      = [null_resource.raspberry_pi_bootstrap]
  create_duration = "90s"
}

resource "null_resource" "next" {
  depends_on = [time_sleep.wait_90_seconds]
}


# Create a new RKE cluster using arguments
resource "rke_cluster" "berrycluster" {
  depends_on = [null_resource.next]
  # rke may complain if the Docker version is newer than what Rancher has tested
  ignore_docker_version = true
  #disable_port_check = true
  dynamic "nodes" {
    for_each = var.nodes
    content {
      # you can use address = nodes.value.ip_addr but this may harm usage with other tf providers
      # otherwise set the ip to name mappings within /etc/hosts
      address = nodes.value.hostname
      user    = var.ssh_user
      role    = nodes.value.role
      ssh_key = var.private_key
    }
  }

  ## limited CNIs running on arm64
  network {
    plugin = "flannel"
  }

  ## default to arm64 versions that seem to work
  system_images {
    alpine                      = "rancher/rke-tools:v0.1.71"
    nginx_proxy                 = "rancher/rke-tools:v0.1.71"
    cert_downloader             = "rancher/rke-tools:v0.1.71"
    kubernetes_services_sidecar = "rancher/rke-tools:v0.1.71"
    nodelocal                   = "rancher/rke-tools:v0.1.71"
    ingress                     = "rancher/nginx-ingress-controller:nginx-0.35.0-rancher2"
    etcd                        = "rancher/coreos-etcd:v3.4.13-arm64"
  }

  upgrade_strategy {
    drain                  = true
    max_unavailable_worker = "20%"
  }
}