#!/bin/bash -e

rm -rf $HOME/gowebapp
sudo kubeadm reset -f
rm $HOME/.kube/config