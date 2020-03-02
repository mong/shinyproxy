#!/bin/bash

### Install script for docker ++ at ubuntu 18.04 (bionic)

# get node name and set env accordingly
echo
read -p 'Please type the node name (e.g. node0): ' node_name
echo
echo Setting up $node_name
echo
cat << EOF >> ~/.profile
export NODE_NAME=$node_name
EOF

# upadate system
sudo apt update

# prerequisites for https apt
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# get GPG key for docker repost
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add apt source
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

# update package database
sudo apt update

# use docker repo rather than ubuntu
apt-cache policy docker-ce

# install docker
sudo apt install -y docker-ce

# add this user to docker group
sudo usermod -aG docker ${USER}

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# provide right mode to binary
sudo chmod +x /usr/local/bin/docker-compose

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

echo
echo Finished
echo
echo Please remember to re-login before running docker-compose
echo

