import time
import datetime
import platform
import os
import shutil

INTERVAL = 5

def get_ram_info():
    meminfo = {}
    with open('/proc/meminfo', 'r') as f:
        for line in f:
            parts = line.split(':')
            meminfo[parts[0]] = int(parts[1].strip().split()[0])
    total = meminfo['MemTotal'] // 1024
    available = meminfo['MemAvailable'] // 1024
    used = total - available
    return total, used, available

def get_cpu_info():
    with open('/proc/cpuinfo', 'r') as f:
        for line in f:
            if 'model name' in line:
                return line.split(':')[1].strip()
    return platform.processor()

while True:
    print("===================================")
    print(f"Data si Ora: {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"OS: {platform.system()} {platform.release()} ({platform.version()})")
    print(f"CPU: {get_cpu_info()}")
    
    try:
        t_ram, u_ram, a_ram = get_ram_info()
        print(f"RAM (MB): Total={t_ram}, Folosit={u_ram}, Disponibil={a_ram}")
    except FileNotFoundError:
        print("RAM: Informatia nu este disponibila (necesita /proc)")

    total_d, used_d, free_d = shutil.disk_usage("/")
    print(f"Disk (GB): Total={total_d // (2**30)}, Folosit={used_d // (2**30)}, Disponibil={free_d // (2**30)}")
    print("===================================")
    
    time.sleep(INTERVAL)
