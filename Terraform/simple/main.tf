# set requirements and versions of the terraform helm provider
terraform {
  required_version = ">= 0.14.0"

  required_providers {
    helm = {
      source = "hashicorp/helm"
      # https://github.com/hashicorp/terraform-provider-helm/issues/893
      # Limit to 2.5 due to K8s alpha APIs
      version = "~> 2.9.0"
    }
    datadog = {
      source = "datadog/datadog"
    }
  }
}

# this provides the helm provider access to your kubernetes cluster
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# resource that creates the datadog helm chart
resource "helm_release" "datadog_agent" {
    name             = "datadog"
    chart            = "datadog"
    repository       = "https://helm.datadoghq.com"
    version          = "3.27.0"

    set_sensitive {
        name  = "datadog.apiKeyExistingSecret"
        value = "datadog-agent"
    }

    set_sensitive {
        name  = "datadog.appKey"
        value = "<MY_APP_KEY>"
    }

    set {
        name  = "datadog.clusterName"
        value = "terrablecluster"
    }

    set {
        name  = "datadog.tags[0]"
        value = "terraform:sandbox"
    }

    set {
        name  = "datadog.kubelet.tlsVerify"
        value = false
    }

    set {
        name  = "datadog.logs.enabled"
        value = true
    }

    set {
        name  = "datadog.logs.containerCollectAll"
        value = true
    }

    set {
        name  = "datadog.logs.containerCollectUsingFiles"
        value = true
    }
    set {
        name  = "datadog.podAnnotationsAsTags"
        value = "instrumentation.opentelemetry.io/inject-java:iotel_enable"
    }

}
