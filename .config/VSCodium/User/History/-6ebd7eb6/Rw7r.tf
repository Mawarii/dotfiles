resource "local_file" "cloud-init" {
  filename = "/tmp/hetzner-cloud-init"
  content  = <<EOT
#cloud-config
users:
  - name: ${var.ssh_user}
    groups: sudo, wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
%{for key in var.ssh_keys~}
      - ${key.key} ${key.name}
%{endfor~}
write_files:
  - path: /etc/ssh/sshd_config.d/ssh-port.conf
    content: |
      # SSHD configuration
      Port ${var.ssh_port}
      PasswordAuthentication no
      PermitRootLogin no
    permissions: '0600'
  - path: /etc/fail2ban/jail.local
    content: |
      [sshd]
      enabled = true
      port = ${var.ssh_port}
    permissions: '0600'
  # Creating an empty auth.log file to ensure that fail2ban does not fail due to a missing log file.
  - path: /var/log/auth.log
    content: ''
    permissions: '0640'
    owner: 'syslog:adm'
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
