resource "local_file" "cloud-init" {
  filename = "/tmp/hetzner-kube-cloud-init"
  content  = <<EOT
#cloud-config
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

#cloud-config
users:
  - name: debian
    groups: sudo, wheel
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      # replace with your keys
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBhsm+GB6c3YlWLwp+eDz+tlBbxPeJW1TO/baxFQYwwk dmarkovic
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILvLeKJ9TuQ2Bq7706L6YVv/8Qh+LDfxmfD0YY6Ijw+f dlehmann
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDhdXtsE9gLAoOmdLz3H/lpxdHcWFSpTdTl6pDNlEhh4eunU1FOCsysJeqzmbvt2LTfFHAxPdA5i8HuNE5/g2MhVjAWBIaEU3GVYIkfXJ/ixBMu7lciF/cGapP0KmWtwTzbDTeEU8BHH+BdH2QyRNh5ymCwwv7XUXFK8G0zC7Rw0bcgWSlmUnFE34m5Z4ztGOEHiG7o3HhtdZ2YkM7OR5fIye33BACuzh9fBQLMNRklnEnSF5T00fDk/TWZoWASraQ2Bl5H1Txxtkf389ZUlCad0EnXzVi6Wb307LD/YNR73goVWQx2LYIl8IO1TJref9paIOzrFV50mJ35OIyFS2jJgerYAtMKiEoAmNrPGP2Xri/3w813PCHRcUAOAEsfTgIYRm3NUIq6NCuq3tUDUYLj7GHTcUhexHyEPN8cI/F7/29ZnsUWy4IpHriJJvy1RmUdQvZr8z2PymyAmR1mCxDMYewzFZUuSdIgXPgJA4Hj6YpVYleQgg5Sq9zxLgdhH1O8zAEPMNIzp2J29U/ncXexO3IH6nUJWnpJG1J2+m5wtcBigsX1rLL1htqhsf6MXYgWvkD0ID8eZTur3Ufi6gex2YF64LDpmkcPJmucHZ8oNqaoU7zR7QKXcbmYx/GM2xpa2d53sf64sHZSd4ipisw7PNoymp0r2vPV5cMFrbhyw== imende
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCt9ijhvX3xqa7CyndaDjmiao93cO1wyVtqIWukSRqmmYzHFRMOPWizvP+mIRwrTERVa7xZnqfkfajko5XG0nqGKuuNq0wSP7iM4jzPSm7SN2OnqcNog3AaxNwvKU/eljLvtKZtsWRVHgMd/liBDarDwebiy3mI2gqnmCJhiFicaZYjHcH1SxIaKSPLTGRjq+M2hIEQp4GFxLULI+uWpXWgPCTb0Z5NYU0PnORTif5zG6lAjHKMVmvYxNTfhxTdo633Z8hmtiyRfUFF1O0/g4yIF/EtgQaH16uR8iQsp1/BxJRrBvjke9i0hHfGHQ6Vf1fALGxbmX9U5djUVB3PoL+87e61SmgTJlWCh0uDljl8u+8qCmWJdIiU4DCEt8DRqkRBf3SU7KmQCCFyXqZh/HnUCBCyDPPSGv/vtbiaJxL++hSjwOap3u2OwaxSYfUhM0SiAO3MTzc4lVs8544Jm65KfsTf/u0knp530OakLuwJEmoSwvXwcenKhEppkCVMUXae0lFEo9vbtpMweeLS+s3u0TadviAA1/9TzJ7LGTnBmhteJYIJS9L6oNl5qu9TDipXtI+2XmPE9XzLiKVVp6uT7lEnVKT4yKYgbglR4X53vruBNaGa17S5XE2T5esbDFwNv5yrgDwiHRZcqr3UdwyOUEvCpK2iZaernLJJaRHWYw== nmerscher
write_files:
  - path: /etc/ssh/sshd_config.d/cloudical.conf
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
package_update: true
packages:
  - ufw
  - fail2ban
  - rsyslog
runcmd:
  - ufw allow 1337/tcp
  - ufw --force enable
  - systemctl enable fail2ban
  - systemctl start fail2ban