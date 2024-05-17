
resource "null_resource" "raspberry_pi_bootstrap" {
  # increment version here if you wish this to run again after running it the first time
  triggers = {
    version = "0.1.2"
  }
  for_each = local.nodes
  connection {
    type        = "ssh"
    user        = local.user
    private_key = file("${path.module}/../${local.private_key}")
    host        = each.value.ip_addr
  }

  # for use with Ubuntu 20.10 for RPi 3 or 4 (arm64 only)
  provisioner "file" {
    destination = "/etc/hosts"
    content = templatefile("${path.module}/templates/hosts.tfpl",{
      hostname = each.value.hostname
      nodes = local.nodes
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