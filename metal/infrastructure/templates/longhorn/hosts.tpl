[longhorn]
%{ for i, ip in hosts ~}
k3s-worker-${i + 1} ansible_host=${ip} ansible_user=ubuntu
%{ endfor ~}

