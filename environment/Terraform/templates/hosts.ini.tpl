[all:vars]
workspace=${workspace}
var_file=${var_file}
docker_user=${docker_user}
docker_password=${docker_password}
docker_mirror_ip=${docker_mirror_ip}

[master]
%{ for node in mapped_nodes ~}%{ if node.is_master == true }
${node.ip} ansible_user=${coalesce(node.ssh_username, ssh_username)} ansible_sudo_pass=${coalesce(node.ssh_password, ssh_password)}
%{ endif }%{ endfor ~}

[node]
%{ for node in mapped_nodes ~}%{ if node.is_master == false }
${node.ip} ansible_user=${coalesce(node.ssh_username, ssh_username)} ansible_sudo_pass=${coalesce(node.ssh_password, ssh_password)}
%{ endif }%{ endfor ~}

[kube-cluster:children]
master
node
