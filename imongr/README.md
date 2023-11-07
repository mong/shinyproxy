Utvalg av kommandoer som ble brukt for å sette opp ny EC2-instans:

```bash
$ history
git clone https://github.com/mong/shinyproxy.git
sudo snap install docker
sudo groupadd docker
sudo usermod -aG docker ${USER}
su -s ${USER}
sudo reboot 
cd shinyproxy/imongr/
vi .profile
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
sudo apt upgrade -y
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF > override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D -H tcp://127.0.0.1:2375 -H unix://
EOF
sudo mv override.conf /etc/systemd/system/docker.service.d/

sudo systemctl daemon-reload
sudo systemctl restart docker
crontab -e
vi /etc/systemd/system/docker.service.d/override.conf # legg inn AWS_ACCESS_KEY_ID og AWS_SECRET_ACCESS_KEY
sudo systemctl daemon-reload
cd shinyproxy/imongr/
sudo systemctl restart docker
docker restart
sudo service docker restart
sudo systemctl status docker
sudo systemctl restart snap.docker.dockerd.service
sudo reboot
docker-compose up
```


```bash
# Installer offisiell versjon av docker. Oppskrift fra https://docs.docker.com/engine/install/ubuntu/
sudo snap remove --purge docker # slette det som ble installert gjennom snap
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done # litt ekstra sletting for sikkerhetsskyld. Ble ikke fjernet noe i dette steget.
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo   "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Oppstart
sudo reboot
cd shinyproxy/imongr/
docker compose up -d # snurr opp i detached mode 
```
