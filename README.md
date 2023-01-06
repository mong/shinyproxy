# Proxy our shiny apps <img src="logo.svg" align="right" height="120" />

## Introduction
Re-using the name of [the underlying Spring boot web application](https://www.shinyproxy.io/) _shinyproxy_ is the deployer of shiny web applications developed and mentained by SKDE. Both _shinyserver_ and the web applications it it a proxy for are deployed as [docker containers](https://www.yr.no/place/Norway/Troms_og_Finnmark/Troms%C3%B8/Troms%C3%B8/hour_by_hour.html) and replicated at a given number of nodes to reduce potential downtime.

![mongr.no shinyproxy setup](mongr_shinyproxy.png)

_shinyproxy_ is part of the [infrastructure at mongr.no](https://github.com/SKDE-Felles/lb-rp) and serves shiny applications such as [qmongr](https://github.com/SKDE-Felles/qmongr).

## Config
Configuration of _shinyproxy_ is defined in the _application.yml_-file. Re-configuration will in most likely occur as a result of new shiny application being added (or old ones removed). For details please see [the ShinyProxy docs](https://www.shinyproxy.io/configuration/).

## Build
Our _shinyproxy_ will itself run as a docker container. To build the corresponding image move into the directory _[project]_ holding the _Dockerfile_ and run
```
docker build -t hnskde/shinyproxy-[project]:latest .
```
Then, push this image to the registry:
```
docker push hnskde/shinyproxy-[project]:latest
```
## Install
All steps are performed from the command line at each server instance (node) that will be running _shinyproxy_.

### First time
Make sure that the current content of this repo is available by using git:
```
git clone https://github.com/mong/shinyproxy.git
```

If the server to be hosting _shinyproxy_ is just created (vanilla state) make sure _docker-ce_ and _docker-compose_ are installed along with other relevant settings. Move into the newly created _shinyproxy_ project directory and run the following script:
```
./install.sh
```

If AWS LogWatch will be used credetials need to be defined and available to docker. Add the following to _/etc/systemd/system/docker.service.d/override.conf_:
```
Environment="AWS_ACCESS_KEY_ID=[some_key_id]" "AWS_SECRET_ACCESS_KEY=[some_seecret_access_key]"
```
Corresponding values are found using the AWS Identity and Access Management (IAM) service. Save the file and reload the daemon
```
sudo systemctl daemon-reload
```
and restart the docker service
```
sudo systemctl restart docker
```
Then, download the latest image from registry:
```
docker pull hnskde/shinyproxy-[project]
```
Repeat the above instructions at all nodes.

### Update
Please note that an update of the _shinyproxy_ will render all shiny applications behind it inaccessible. Therefore, make sure to perform all the following steps one __node at a time__. This will make sure that while one node is down for an update the other nodes will still serve users of the shiny applications. 

First, make sure to download the latest update of the _shinyproxy_ image from the registry:
```
docker pull hnskde/shinyproxy-[project]
```
If the update also includes changes of _docker-compose.yml_ get the latest version using git:
```
git pull origin main
```

Then, take down _shinyproxy_ docker container:
```
docker-compose down
```
and clean up old images and containers:
```
docker system prune
```
Finally, bring up the updated _shinyproxy_ container:
```
docker-compose up -d
```

Repeat the above steps on all nodes.

## Start and stop service
To enable _shinyproxy_ use _docker-compose_ to start the relevant services in detached mode. Move into the _shinyproxy_ directory and run:
```
docker-compose up -d
```

To stop it do:
```
docker-compose down
```

To bring the services down an up again in one go do:
```
docker-compose restart
```

For other options please consult [the docker compose docs](https://docs.docker.com/compose/).

## Note on shiny applications

### Install
_shinyproxy_ do not pull images from remote registries. To make images available locally at each node these have to be pulled the first time they are used, _e.g._
```
docker pull hnskde/qmongr
```

### Update
Updating the shiny applications is a somewhat different process and part of a continuous integration and delivery (ci/cd) scheme. At each node running _shinyproxy_ a cron job is defined to trigger update routine every 5 minutes on weekdays:
```
*/5 * * * 1-5 $HOME/shinyproxy/update_images.sh >/dev/null 2>&1
```
If updates are found the corresponding images are downloaded. A new version of a shiny application will be available once _shinyproxy_ restarts the corresonding container from the updated image. 
