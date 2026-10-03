#!/usr/bin/env bash
# Comandos de referencia para ejecutar MANUALMENTE en el nodo correspondiente.
# No ejecutar el archivo completo en un solo host.

# PC-1 / VLAN 10
ip -br addr show ens3
curl http://10.6.94.2
curl http://10.6.94.3
timeout 8 ssh -o ConnectTimeout=5 ubuntu@10.6.94.4

# PC-2 / VLAN 20
ip -br addr show ens3
curl http://10.6.94.3
# ssh ubuntu@10.6.94.4   # solicita credenciales interactivamente

# Web-Caja / DMZ
ping -c 4 10.6.93.10
ping -c 4 8.8.8.8
sudo apt update

# DB-Server
sudo ufw status numbered
sudo ss -lntp | grep -E '(:22|:3306)'
