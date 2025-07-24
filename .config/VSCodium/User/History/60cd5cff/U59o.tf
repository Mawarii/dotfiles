resource "local_file" "inventory" {
  filename = "local/inventory"
  content  = <<-EOF
[control-plane]
%{for machine in hcloud_server.control-planes~}
${machine.name} ansible_host=${machine.ipv4_address} ansible_user=${var.ssh_user} ansible_port=${var.ssh_port}
%{endfor~}

[nodes]
%{for machine in hcloud_server.worker~}
${machine.name} ansible_host=${machine.ipv4_address} ansible_user=${var.ssh_user} ansible_port=${var.ssh_port}
%{endfor~}
EOF
}
