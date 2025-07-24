resource "local_file" "cloud-init" {
  filename = "/tmp/hetzner-kube-cloud-init"
  content  = <<EOT
#cloud-config
users:
  - name: debian
    groups: sudo, wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
%{for key in var.ssh_key~}
      - ${key.key} ${key.name}
%{endfor~}
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhsm+GB6c3YlWLwp+eDz+tlBbxPeJW1TO/baxFQYwwk dmarkovic
write_files:
  - path: /etc/ssh/sshd_config.d/ssh-port.conf
    content: |
      # SSHD configuration
      Port 1337
      PasswordAuthentication no
      PermitRootLogin no
    permissions: '0600'
  - path: /etc/fail2ban/jail.local
    content: |
      [sshd]
      enabled = true
      port = 1337
    permissions: '0600'
  # Creating an empty auth.log file to ensure that fail2ban does not fail due to a missing log file.
  - path: /var/log/auth.log
    content: ''
    permissions: '0640'
    owner: 'syslog:adm'
# mirror setup
apt:
  sources:
    kubernetes.list:
      source: "deb [signed-by=$KEY_FILE] https://pkgs.k8s.io/core:/stable:/v${var.kube_version}/deb/ /"
      keyid: DE15B14486CD377B9E876E1A234654DA9A296436
      filename: kubernetes.list
    crio.list:
      source: "deb [signed-by=$KEY_FILE] https://pkgs.k8s.io/addons:/cri-o:/stable:/v${var.kube_version}/deb/ /"
      keyid: DE15B14486CD377B9E876E1A234654DA9A296436
      filename: crio.list
    kubic.list:
      source: "deb [signed-by=$KEY_FILE] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/Debian_12/ /"
      keyid: 2472D6D0D2F66AF87ABA8DA34D64390375060AA4
      filename: kubic.list
# install packages
package_update: true
packages:
  - fail2ban
  - rsyslog
runcmd:
  - |
    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    overlay
    br_netfilter
    EOF
  - |
    cat <<EOF | tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-iptables  = 1
    net.bridge.bridge-nf-call-ip6tables = 1
    net.ipv4.ip_forward                 = 1
    EOF
  - sudo modprobe overlay 
  - sudo modprobe br_netfilter 
  - sysctl -p
  - sudo rm -rf "/etc/cni/net.d/*"
  - systemctl enable fail2ban
  - systemctl start fail2ban
EOT
}
