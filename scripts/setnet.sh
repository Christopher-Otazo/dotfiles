#!/bin/bash
INTERFACE="enp0s3"

STATIC_IP="192.168.10.5/24"
STATIC_GW="192.168.10.1"

function set_hacking_mode(){

	echo"Cambiando a HackerMode uwu (IP Estatica: $STATIC_IP)..."
	sudo nmcli con mod $INTERFACE ipv4.method manual ipv4.addresses $STATIC_IP ipv4.gateway $STATIC_GW ipv4.dns ""
	sudo nmcli con down $INTERFACE && sudo nmcli con up $INTERFACE
	
	echo "HackerMode activado. Verificar con 'ip a'."
	echo "	*Gateway (Target): $STATIC_GW"
}

function set_internet_mode() {

	echo "Cambiando a Modo Internet (DHCP)..."
	sudo nmcli con mod $INTERFACE ipv4.method auto ipv4.addresses "" ipv4.gateway "" ipv4.dns ""
	sudo nmcli con down $INTERFACE && sudo nmcli con up $INTERFACE
	
	echo "Restaurando DNS 8.8.8.8 en /etc/systemd/resolved.conf"
	sudo sed -i '/^DNS=/c\DNS=8.8.8.8 8.8.4.4' /etc/systemd/resolved.conf
	sudo systemctl restart systemd-resolved

	echo "Modo Internet activado. Verificar con 'ping google.com'."
}

if ["$1" == "hack"]; then
	set_hacking_mode
elif ["$1" == "internet"]; then
	set_internet_mode
else
	echo "Uso: sudo ./setnet.sh [hack | internet]"
	echo "Ejemplo: Para Internet: sudo ./setnet.sh internet"
	echo "Ejemplo: Para Hacking: sudo ./setnet.sh hack (Requiere VirtualBox en Host-Only)"
fi
