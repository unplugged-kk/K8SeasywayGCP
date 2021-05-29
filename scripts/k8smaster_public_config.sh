#! /bin/sh

read -p " Enter the Public ip of the master: "

# IPADDR=`ip a|grep inet|head -3|tail -1|cut -c10-20`

NODENAME=$(hostname -s)

sudo kubeadm init --apiserver-advertise-address=$IPADDR  --apiserver-cert-extra-sans=$IPADDR  --pod-network-cidr=10.241.0.0/16 --node-name $NODENAME --ignore-preflight-errors Swap


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

curl https://docs.projectcalico.org/manifests/calico.yaml -O

kubectl apply -f calico.yaml
