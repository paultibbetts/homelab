[master]
%{ for ip in k3s_leaders ~}
${ip}
%{ endfor ~}

[node]
%{ for ip in k3s_workers ~}
${ip}
%{ endfor ~}

[k3s_cluster:children]
master
node