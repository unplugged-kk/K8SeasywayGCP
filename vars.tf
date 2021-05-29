variable "project" {
    type = string
    default = ""
}

variable "region" {
    type = string
    default = ""
}

variable "zone" {
    type = string
    default = ""
}

variable "network" {
    type = string
    default = "default"
}

variable "subnetwork" {
     type = string
     default = "" 
}

variable "ip_range_pods" {
     type = string
     default = "" 
}

variable "ip_range_services" {
     type = string
     default = "" 
}

variable "k8smaster_script_path" {
    type = string
    default = ""
}

variable "k8sworker_script_path" {
    type = string
    default = ""
}

variable "username" {
     type = string
     default = "" 
}

variable "private_key_path" {
     type = string
     default = "" 
}
