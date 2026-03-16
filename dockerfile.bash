FROM ubuntu:22.04
# Actualizare si instalare pachete esentiale pentru comenzile lscpu, free, etc.
RUN apt-get update && apt-get install -y util-linux procps coreutils && rm -rf /var/lib/apt/lists/*
COPY monitor.sh /usr/local/bin/monitor.sh
RUN chmod +x /usr/local/bin/monitor.sh
CMD ["/usr/local/bin/monitor.sh"]
