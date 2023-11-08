#!/bin/bash

### Install script for docker ++ at ubuntu

# get node name and set env accordingly
echo
read -p 'Please type the node name (e.g. node0): ' node_name
echo
echo Setting up $node_name
echo
cat << EOF >> ~/.profile
export NODE_NAME=$node_name
EOF

echo
read -p 'Please type the database host name (e.g. 192.168.0.2): ' db_host_name
echo
echo Setting up $db_host_name
echo
cat << EOF >> ~/.profile
export IMONGR_DB_HOST=$db_host_name
EOF

echo
read -p 'Please type the name of the qmongr database (e.g. imongr): ' db_name
echo
echo Setting up $db_name
echo
cat << EOF >> ~/.profile
export IMONGR_DB_NAME=$db_name
EOF

echo
read -p 'Please type the user name of the qmongr database (e.g. imongr): ' user_name
echo
echo Setting up $user_name
echo
cat << EOF >> ~/.profile
export IMONGR_DB_USER=$user_name
EOF

echo
read -p 'Please type the password of the qmongr database user: ' user_pass
echo
echo Setting up password
echo
cat << EOF >> ~/.profile
export IMONGR_DB_PASS=$user_pass
EOF

echo
read -p 'Please type the adminer url (in the form ip:port): ' adminer_url
echo
echo Setting up adminer host
echo
cat << EOF >> ~/.profile
export IMONGR_ADMINER_URL=$adminer_url
EOF

echo
read -p 'Please type the openid client id: ' client_id
echo
echo Setting up openid client id
echo
cat << EOF >> ~/.profile
export OPENID_CLIENT_ID=$client_id
EOF

echo
read -p 'Please type the openid client secret: ' client_secret
echo
echo Setting up openid client secret
echo
cat << EOF >> ~/.profile
export OPENID_CLIENT_SECRET=$client_secret
EOF

# uninstall all conflicting packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Set up Docker's apt repository.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the Docker packages.

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create the docker group.
sudo groupadd docker
# Add user to docker group
sudo usermod -aG docker ${USER}
# su -s ${USER} (not needed?)

# enable (shinyproxy) tcp communication with dockerd on localhost
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF > override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -D -H tcp://127.0.0.1:2375 -H unix://
EOF
sudo mv override.conf /etc/systemd/system/docker.service.d/

# (re)start dockerd
sudo systemctl daemon-reload
sudo systemctl restart docker

# Make crontab entry for docker image updates
# Every 5 min Monday throug Friday
echo
echo Setting up cron job for continuous docker image updates
echo
crontab -l > current
echo "*/5 * * * 1-5 $HOME/shinyproxy/update_images.sh >/dev/null 2>&1" >> current
crontab current
rm current

current=`crontab -l`
echo
echo Now, current crontab is:
echo
echo "$current"
echo

echo
echo Finished
echo
echo Please remember to add aws key/secrets to /etc/systemd/system/docker.service.d/awslogs.conf, restart the docker daemon (sudo systemctl daemon-reload) and re-login before running docker-compose
echo
