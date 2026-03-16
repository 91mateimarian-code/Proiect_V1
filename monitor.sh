#!/bin/bash
# monitor.sh

INTERVAL=5

while true; do
    echo "==================================="
    echo "Data si Ora: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
    echo "CPU: $(lscpu | grep 'Model name' | awk -F: '{print $2}' | sed 's/^[ \t]*//')"
    
    # Procesare memorie
    read -r total_ram used_ram free_ram <<< $(free -m | awk 'NR==2 {print $2, $3, $4}')
    echo "RAM (MB): Total=${total_ram}, Folosit=${used_ram}, Disponibil=${free_ram}"
    
    # Procesare disc (partitia root)
    read -r total_disk used_disk free_disk <<< $(df -h / | awk 'NR==2 {print $2, $3, $4}')
    echo "Disk (/): Total=${total_disk}, Folosit=${used_disk}, Disponibil=${free_disk}"
    echo "==================================="
    
    sleep $INTERVAL
done
