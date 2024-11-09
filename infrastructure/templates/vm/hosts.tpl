%{ for ip in ips ~}
${name} ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}
