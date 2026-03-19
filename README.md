# 🚀 Proiect Final DevOps: Monitorizare și Automatizare IaC

Acest repository conține implementarea unui ciclu complet DevOps pentru monitorizarea resurselor sistemului, containerizarea agenților și automatizarea infrastructurii prin **Ansible**.

## 🏗️ Arhitectura Proiectului
* **Agenți de Monitorizare:** Scripturi Bash și Python (interogare nativă `/proc`, fără dependențe externe).
* **Containerizare:** Docker și Docker Compose (izolare procese și orchestrare servicii).
* **Configuration Management:** Ansible (Provisioning utilizatori, Deployment artefacte, Decommissioning).

---

## 💻 Etape, Comenzi și Validări

### Pasul A: Agenții de Monitorizare (Execuție Locală)
Am dezvoltat doi agenți independenți cu bucle infinite și temporizare, care extrag metricile hardware ale sistemului de operare.

**Comenzi de execuție:**
`chmod +x monitor.sh`
`./monitor.sh`
`python3 monitor.py`

**Output validare (Extras):**
> ===================================
> Data si Ora: 2026-03-14 14:12:30
> OS: Ubuntu 24.04.3 LTS
> CPU: 13th Gen Intel(R) Core(TM) i7-13700F
> RAM (MB): Total=8180, Folosit=2053, Disponibil=2716
> ===================================

### Pasul B & C: Containerizare și Docker Compose
S-au utilizat imaginile de bază `ubuntu:24.04` și `python:3.11-slim`. I/O buffering-ul Python a fost suprascris prin directiva `ENV PYTHONUNBUFFERED=1` în Dockerfile.

**Comenzi de execuție:**
`docker compose up -d --build`
`docker logs -f container-python`

**Output validare (Extras):**
> [+] Building 0.4s (1/1) FINISHED
>  => [internal] load local bake definitions
> ...
> Data si Ora: 2026-03-15 11:32:54
> OS: Linux 6.8.0-101-generic
> RAM (MB): Total=8180, Folosit=671, Disponibil=7509

### Pasul D: Provisioning Ansible (Utilizator și Permisiuni)
Playbook idempotent pentru crearea utilizatorului limitat `ansible_admin` cu privilegii de execuție Docker și Sudo.

**Comandă de execuție:**
`ansible-playbook playbook_step_d.yaml --ask-become-pass`

**Output validare (Extras):**
> TASK [1. Asigurarea prezenței grupului Docker în sistem] ***
> ok: [localhost]
> TASK [2. Crearea contului de utilizator cu privilegii depline] ***
> changed: [localhost]
> ...
> PLAY RECAP ***
> localhost : ok=4  changed=2  unreachable=0  failed=0

### Pasul E: Deployment Securizat
S-a gestionat delegarea permisiunilor prin instalarea pachetului `acl` și s-a lansat arhitectura Docker sub noul utilizator.

**Comandă de execuție:**
`ansible-playbook playbook_step_e.yaml --ask-become-pass`

**Output validare (Extras):**
> TASK [0. Instalarea pachetului ACL] ***
> ok: [localhost]
> TASK [1. Transferul artefactelor sursa si setarea proprietatii] ***
> changed: [localhost] => (item=docker-compose.yaml)
> ...
> TASK [2. Pornirea arhitecturii prin utilizatorul creat la Pasul D] ***
> changed: [localhost]

### Pasul F: Decommissioning (Cleanup)
Ștergerea containerelor, a rețelelor virtuale și eliminarea completă a utilizatorului din sistem (igienizare completă).

**Comandă de execuție:**
`ansible-playbook playbook_step_f.yaml --ask-become-pass`

**Output validare (Extras):**
> TASK [1. Oprirea si dezafectarea containerelor Docker Compose] ***
> changed: [localhost]
> TASK [3. Eliminarea utilizatorului DevOps si curatarea directorului home] ***
> changed: [localhost]
