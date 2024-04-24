[gitea]
%{ for i, ip in ips ~}
gitea-${i + 1} ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}
