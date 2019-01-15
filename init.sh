#!/bin/bash
##########################################################################
# script to check if the jwilder proxy container is already running
# and if the ngnix-proxy network exists
# run before "docker-compose up -d" if you use nginx-proxy for several projects
# see https://github.com/docker/compose/issues/2075
##########################################################################

export COMPOSE_CONVERT_WINDOWS_PATHS=1
export $(egrep -v '^#' .env | xargs)

if [ ! "$(docker network ls | grep dev-frontend)" ]; then
  echo "Creating dev-frontend network ..."
  docker network create dev-frontend
else
  echo "dev-frontend network exists."
fi

if [ ! "$(docker network ls | grep dev-backend)" ]; then
  echo "Creating dev-backend network ..."
  docker network create dev-backend
else
  echo "dev-backend network exists."
fi

if [ ! "$(docker ps | grep dev-proxy)" ]; then
    if [ "$(docker ps -aq -f name=dev-proxy)" ]; then
        # cleanup
        echo "Cleaning Proxy and tools ..."
        docker-compose down
    fi
    # run your container in our global network shared by different projects
    echo "Running Nginx Proxy and proxy in global dev-proxy network ..."
    # docker run -d --name dev-proxy -p 80:80 -p 443:443 --restart always --network=dev-proxy -v //var/run/docker.sock:/tmp/docker.sock:ro -v "${PWD}conf/limits.conf:/etc/nginx/conf.d/limits.conf:ro" -v "${PWD}conf/perfs.conf:/etc/nginx/conf.d/perfs.conf:ro" -v "${PWD}conf/security.conf:/etc/nginx/conf.d/security.conf:ro" -v "${PWD}conf/proxy.conf:/etc/nginx/proxy.conf:ro" jwilder/nginx-proxy:alpine
    docker-compose up -d
else
  echo "Nginx Proxy already running."
fi
echo "You can now run containers with VIRTUAL_HOST env var !"
  
# echo "Adding scripts to $( cd ~/bin && pwd ) ..."
# # mkdir -p ~/bin
# if [ ! -f "$( cd ~/bin && pwd )/docker-init-stack" ]; then
#   echo "Adding docker-init-stack ..."
#   ln -sf "$( pwd )/bin/docker-init-stack" "$( cd ~/bin && pwd )"
# fi

# HOSTSFILE="C:\Windows\System32\Drivers\etc\hosts"
# cat ${HOSTFILE}
# if [ ! "$(cat ${HOSTFILE} | grep portainer.local)" ]; then
#     # add portainer.local to hosts file
#     echo "Adding portainer.local to hosts file ${HOSTFILE} ..."
#     echo "127.0.0.1 portainer.local portainer" >> "${HOSTFILE}"
# else
#   echo "portainer.local already in hosts file."
# fi
