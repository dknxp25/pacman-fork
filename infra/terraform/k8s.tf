terraform {
  required_providers {
    twc = {
      source = "tf.timeweb.cloud/timeweb-cloud/timeweb-cloud"
    }
  }
  required_version = ">= 0.13"
}

data "twc_projects" "project" {
  name = "pacman-project"
}

data "twc_k8s_preset" "k8s-preset-master" {
  type = "master"
  location = "ru-1"
  price_filter {
    from = 200
    to = 200
  }
}

data "twc_k8s_preset" "k8s-preset-worker" {
  type = "worker"
  location = "ru-1"
  price_filter {
    from = 890
    to = 890
  }
}

resource "twc_k8s_cluster" "k8s-cluster" {
  name = "k8s-cluster"
  project_id = data.twc_projects.project.id
  version = "v1.32.3+k0s.0"
  network_driver = "calico"
  ingress = true
  preset_id = data.twc_k8s_preset.k8s-preset-master.id
}

resource "twc_k8s_node_group" "k8s-node" {
  cluster_id = twc_k8s_cluster.k8s-cluster.id
  name = "k8s-node"
  node_count = 2
  preset_id = data.twc_k8s_preset.k8s-preset-worker.id
}