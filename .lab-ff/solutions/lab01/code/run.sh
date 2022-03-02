#!/bin/bash -e

export DEFAULT_REGISTRY="localhost:5000"
# if running in Educates, then REGISTRY_HOST will be set and used, otherwise default to Strigo registry
export REGISTRY="${REGISTRY_HOST:-$DEFAULT_REGISTRY}"

export DEFAULT_WEBSERVER="http://localhost:8081"
export WEBSERVER="${WEBSERVER:-$DEFAULT_WEBSERVER}"

kubectl get pods > /dev/null 2>&1 || k8s-start

if [ ! -d "$HOME/gowebapp" ]
then
    pushd `pwd`
    cd
    curl -s ${WEBSERVER}/_static/lab-files.tar.gz | tar -xzv
    popd
fi

cd $HOME/gowebapp/gowebapp
docker build -t gowebapp:v1 .

cd $HOME/gowebapp/gowebapp-mysql
docker build -t gowebapp-mysql:v1 .

docker network create gowebapp || true

docker tag gowebapp:v1 ${REGISTRY}/gowebapp:v1
docker tag gowebapp-mysql:v1 ${REGISTRY}/gowebapp-mysql:v1

docker push ${REGISTRY}/gowebapp:v1
docker push ${REGISTRY}/gowebapp-mysql:v1