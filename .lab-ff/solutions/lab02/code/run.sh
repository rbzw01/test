#!/bin/bash -e

kubectl apply -f $HOME/gowebapp/gowebapp-mysql

sleep 10

kubectl apply -f $HOME/gowebapp/gowebapp