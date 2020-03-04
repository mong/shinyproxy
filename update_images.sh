#!/bin/bash

# Pull updated imgages of runnig containers

## Define relevant docker label for filtering here
filter="label=no.mongr.cd.enable=true"

## Get relevant images
images=`docker ps --filter $filter --format {{.Image}}`

## Update candidates
echo Checking for updates...
for image in $images; do
  docker pull $image;
done

echo Finished

