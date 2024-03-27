terraform {
  cloud {
    organization = "XiangLiOrg"

    workspaces {
      name = "k8sproject"
    }
  }
}