# Prerequesites

A GCP Account
Terraform installed in your PC/MAC/Linux
GCP Service account. create it and generate json key for TF use / authenticate your system by using gcloud init.

K8S Easy Way ( Kubeadm )

This contains the Terraform code to deploy the infrastructure in GCP and bootstrap form scratch.

Once TF code runs 2 manual steps are need to be done. login to the k8s-worker1 , k8s-worker2 and run the below join command to join as a node to the k8s-master.

sudo kubeadm join 10.240.0.10:6443 --token <token-id> \
--discovery-token-ca-cert-hash <token-hash>

if you have differnt path for the script / username / ssh key it can be changed in terraform.tfvars