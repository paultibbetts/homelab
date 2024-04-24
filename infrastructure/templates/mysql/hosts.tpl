[mysql]
%{ for i, ip in ips ~}
mysql-${i + 1} ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}
