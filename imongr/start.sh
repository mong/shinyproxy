# Har lagt til azureuser i docker
# sudo usermod -aG docker azureuser

# Har lagt inn tillatelse til docker.sock i /etc/systemd/system/docker.service.d/override.conf
# [Service]
# ExecStart=
# ExecStart=/usr/bin/dockerd -D -H tcp://127.0.0.1:2375 -H unix://
# ExecStartPost=/bin/sh -c 'chown azureuser:docker /run/docker.sock'
#
#

# Har lagt inn log-directories
#sudo mkdir -p /var/log/shinyproxy
#sudo chown -R azureuser:docker /var/log/shinyproxy/
#sudo chmod -R 755 /var/log/shinyproxy/
#sudo mkdir -p /var/log/shinyproxy/container-logs
#sudo chown -R azureuser:shinyproxy /var/log/shinyproxy/container-logs
#sudo chmod -R 755 /var/log/shinyproxy/container-logs

# Automatisk sletting av gamle container-logger gjøres med crontab (crontab -e)
# 0 0 * * * /usr/bin/find /var/log/shinyproxy/container-logs -name "*.log" -type f -mtime +7 -exec rm -f {} \;

docker-compose down
docker-compose up --build -d

