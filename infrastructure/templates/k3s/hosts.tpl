[master]
%{ for i, ip in k3s_leaders ~}
k3s_leader-${i + 1} ansible_host=${ip}
%{ endfor ~}

[node]
%{ for i, ip in k3s_workers ~}
k3s_worker-${i + 1} ansible_host=${ip}
%{ endfor ~}

[k3s_cluster:children]
master
node
