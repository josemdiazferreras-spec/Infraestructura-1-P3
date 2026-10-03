# Práctica 3 — Infraestructura 1

## 🎥 Video demostrativo

**YouTube:** https://youtu.be/ruTxFJ0YvJU

**Estudiante:** José Miguel Díaz Ferreras  
**Matrícula:** 2025-0693  
**Asignatura:** Seguridad de Redes

![Topología de Infraestructura 1 en GNS3](evidencias/image(20261003-015540).png)

## Propósito

Implementar y validar una infraestructura segmentada en GNS3 utilizando FortiGate, VLAN, DMZ y controles de seguridad de Capa 2. La solución aplica mínimo privilegio entre usuarios, servidores y WAN, restringe la administración SSH, bloquea el acceso no autorizado a Web Inventario y limita la salida de la DMZ a los destinos de actualización autorizados.

## Arquitectura

| Segmento | VLAN | Red | Gateway | Asignación |
|---|---:|---|---|---|
| Usuarios 1 | 10 | 10.6.93.0/25 | 10.6.93.1 | DHCP 10.6.93.10–100 |
| Usuarios 2 | 20 | 10.6.93.128/25 | 10.6.93.129 | DHCP 10.6.93.150–250 |
| DMZ | 30 | 10.6.94.0/28 | 10.6.94.1 | Estática |
| Web-Caja | 30 | 10.6.94.0/28 | 10.6.94.1 | 10.6.94.2 |
| Web-Inventario | 30 | 10.6.94.0/28 | 10.6.94.1 | 10.6.94.3 |
| DB-Server | 30 | 10.6.94.0/28 | 10.6.94.1 | 10.6.94.4 |

## Controles implementados

- VLAN 10 y VLAN 20 con DHCP.
- VLAN 30 como DMZ con direccionamiento estático.
- Solo VLAN 20 puede administrar los servidores mediante SSH.
- VLAN 10 puede acceder a Web-Caja, pero Web-Inventario es bloqueado mediante Web Filter y página personalizada de violación.
- La DMZ no puede iniciar tráfico hacia las LAN.
- La DMZ no posee Internet general abierto; se permiten repositorios Ubuntu autorizados para actualizaciones.
- MariaDB acepta TCP/3306 desde los servidores web autorizados.
- Switch con port-security sticky, DHCP Snooping, Dynamic ARP Inspection, PortFast, BPDU Guard y puertos no usados en VLAN 999/shutdown.
- Registro de sesiones y bloqueos en FortiGate.

## Políticas principales del FortiGate

| # | Política | Acción |
|---:|---|---|
| 1 | VLAN20-SSH-DMZ | Permite SSH/PING desde VLAN 20 hacia DMZ |
| 2 | VLAN10-INV-WEBFILTER | HTTP a Inventario sujeto a BLOQUEO-INVENTARIO |
| 3 | VLAN10-CAJA | Permite HTTP/HTTPS a Web-Caja |
| 4 | VLAN20-WEB | Permite HTTP/HTTPS a servidores web |
| 5 | VLAN10-DENY-DMZ | Deniega el resto de VLAN 10 hacia DMZ |
| 6 | DMZ-DENY-LAN | Impide conexiones iniciadas desde DMZ hacia LAN |
| 7 | DMZ-UPDATES | Permite HTTP/HTTPS a destinos de actualización autorizados |
| 8 | DMZ-DENY-WAN | Deniega el resto de DMZ hacia WAN |
| 9 | LAN-INTERNET | Permite salida de las VLAN de usuarios con NAT |

## Documentación y archivos

- [`docs/Documento_Tecnico_Practica3_Infraestructura1_2025-0693.docx`](docs/Documento_Tecnico_Practica3_Infraestructura1_2025-0693.docx) — documento técnico completo con diagramas y evidencias.
- [`configs/FortiGate_Infra1_2025-0693_SANITIZADO.conf`](configs/FortiGate_Infra1_2025-0693_SANITIZADO.conf) — backup sanitizado del FortiGate.
- [`configs/SW-0693_running-config_SANITIZADO.txt`](configs/SW-0693_running-config_SANITIZADO.txt) — configuración documentada del switch, sin secretos.
- [`configs/netplan/`](configs/netplan/) — configuraciones de red de los servidores DMZ.
- [`scripts/`](scripts/) — scripts/comandos reproducibles utilizados para servicios y validación.
- [`evidencias/`](evidencias/) — capturas relevantes de la implementación y pruebas.

## Resultados verificados

| Validación | Resultado |
|---|---|
| PC-1 obtiene DHCP en VLAN 10 | Cumple |
| PC-2 obtiene DHCP en VLAN 20 | Cumple |
| VLAN 20 → SSH DMZ | Permitido |
| VLAN 10 → SSH DMZ | Bloqueado |
| VLAN 10 → Web-Caja | Permitido |
| VLAN 10 → Web-Inventario | Bloqueado con página de violación |
| VLAN 20 → Web-Inventario | Permitido |
| DMZ → LAN | Bloqueado |
| DMZ → Internet general | Bloqueado |
| DMZ → repositorios Ubuntu autorizados | Permitido |
| Web-Caja/Web-Inventario → DB TCP/3306 | Permitido |
| VLAN 10 → DB TCP/3306 | Bloqueado |

## Seguridad del repositorio

Las configuraciones publicadas están sanitizadas. No se incluyen contraseñas, claves privadas, PSK, tokens ni credenciales `ENC` del backup original del FortiGate.
