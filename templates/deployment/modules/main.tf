# integrate with helper maps for object ownership

locals {
  app_instance = "${var.service_name}-${var.instance_name}"
  app_team = "inception-scrum" // use your own team name here
  app_product = "CoreServices" // use appropriate product (e.g. TivoService) here
  app_initiative = "ServicePlatform" // use appropriate initiative here
}

locals {
  owner_labels = {
    "app.kubernetes.io/name" = var.service_name
    "app.kubernetes.io/instance" = local.app_instance
    "app.kubernetes.io/part-of" = local.app_initiative
    "inception.tivo.com/owner" = var.deployment_owner
    "inception.tivo.com/team" = local.app_team
    "inception.tivo.com/product" = local.app_product
    "inception.tivo.com/env" = var.bs35_environment_name
  }
  owner_annotations = {
    "inception.tivo.com/email" = var.owner_email
    "inception.tivo.com/slack" = var.owner_slack
  }
}


resource "kubernetes_pod_disruption_budget_v1" "kafka_collector" {
  metadata {
    name = local.app_instance
    namespace = var.namespace
  }
  spec {
    max_unavailable = var.pdb_max_unavailable  // other values or a percentage might make more sense for your workload
    selector {
      match_labels = {
        app = local.app_instance // must match deployment pod selector
      }
    }
  }
}



resource "kubernetes_horizontal_pod_autoscaler_v2" "kafka_collector" {
  metadata {
    name = local.app_instance
    namespace = var.namespace
  }
  spec {
    max_replicas = var.hpa_spec_max_replicas
    min_replicas = var.hpa_spec_min_replicas
    scale_target_ref {
      api_version = "apps/v1"
      kind = "Deployment"
      name = local.app_instance
    }
    metric {
      type = "Resource"
      resource {
        name = "cpu"
        target {
          type = "Utilization"
          average_utilization = var.hpa_spec_metric_cpu_utilization_average_utilization // a different average utilization might be more appropriate for your service
        }
      }
    }
  }
}


resource "kubernetes_deployment_v1" "kafka_collector" {
  metadata {
    name = local.app_instance
    namespace = var.namespace
    labels = local.owner_labels
    annotations = local.owner_annotations
  }

  timeouts {
    create = var.deployment_timeouts_create
    update = var.deployment_timeouts_update
  }

  spec {
    selector {
      match_labels = {
        app = local.app_instance
      }
    }

    template {
      metadata {
        labels = {
          app = local.app_instance
        }
      }
      spec {
        topology_spread_constraint {
          max_skew = var.deployment_spec_template_spec_max_skew
          topology_key = "topology.kubernetes.io/zone"
          when_unsatisfiable = "ScheduleAnyway"
          label_selector {
            match_labels = {
              app = local.app_instance
            }
          }
        }
        topology_spread_constraint {
          max_skew = var.deployment_spec_template_spec_topology_spread_constraint
          topology_key = "kubernetes.io/hostname"
          when_unsatisfiable = "ScheduleAnyway"
          label_selector {
            match_labels = {
              app = local.app_instance
            }
          }
        }
        termination_grace_period_seconds = var.termination_grace_period_seconds
        container {
          name              = "k8s-bs35-proxy"
          image             = var.sidecar_image
          port {
            container_port = var.proxy_sidecar_port
            name           = "proxy-service"
          }
          volume_mount {
            name = "config"
            mount_path = "/TivoData/config"
          }
          volume_mount {
            mount_path = "/TivoData/Log"
            name       = "logdir"
          }
          volume_mount {
            mount_path = "/tmp"
            name = "tmp"
          }
          lifecycle {
            post_start {
              exec {
                command = ["sh", "-c", "wait_until_startup.sh"]
              }
            }
          }
          liveness_probe {
            exec {
              command = ["sh", "-c", "check_proxy.sh"]
            }
            period_seconds = 5
            failure_threshold = 1
            initial_delay_seconds = 5
          }
          env {
            name  = "SVC_PORT"
            value = var.service_port
          }
          env {
            name  = "GLUE_PORT"
            value = var.proxy_sidecar_port
          }
          env {
            name  = "DATACENTER"
            value = var.bs35_datacenter
          }
          env {
            name  = "TERMINATION_GRACE_PERIOD_SECONDS"
            value = var.termination_grace_period_seconds
          }
          env {
            name = "ENVIRONMENT_NAME"
            value = var.bs35_environment_name
          }
          resources {
            limits = {
              cpu = var.cpu_limit
              memory = var.memory_limit
            }
            requests = {
              cpu = var.cpu_request
              memory = var.memory_request
            }
          }
        }
        container {
          name = var.service_name
          image = var.image
          image_pull_policy = "Always"
          readiness_probe {
            http_get {
              path = "/ready"
              port = var.proxy_sidecar_port
            }
            period_seconds        = 10
            initial_delay_seconds = 60
          }
          liveness_probe {
            http_get {
              path = "/alive"
              port = var.proxy_sidecar_port
            }
            period_seconds = 10
            failure_threshold = 3
            initial_delay_seconds = 60
          }
          lifecycle {
            pre_stop {
              http_get {
                path = "/requestShutdown"
                port = var.proxy_sidecar_port
              }
            }
            post_start {
              http_get {
                path = "/mainContainerStarted"
                port = var.proxy_sidecar_port
              }
            }
          }
          port {
            container_port = var.service_port
            name = "service"
          }
          volume_mount {
            mount_path = "/TivoData"
            name = "tivodata"
          }
          volume_mount {
            mount_path = "/TivoData/Log"
            name       = "logdir"
          }
          volume_mount {
            mount_path = "/tmp"
            name = "tmp"
          }
          env {
            name = "LOGBACK_CONFIG"
            value = "logback-stdout.xml"
          }
          env {
            name = "CONTAINER_NAME"
            value = local.app_instance
          }
          env {
            name = "DATACENTER_NAME"
            value = var.bs35_datacenter
          }
          env {
            name = "ENVIRONMENT_NAME"
            value = var.bs35_environment_name
          }
          env {
            name = "REGION_NAME"
            value = var.bs35_region_name
          }
          resources {
            limits = {
              cpu = var.cpu_limit
              memory = var.memory_limit
            }
            requests = {
              cpu = var.cpu_request
              memory = var.memory_request
            }
          }
        }
        volume {
          name = "logdir"
          empty_dir {}
        }
        volume {
          name = "config"
          config_map {
            name = var.app_config
          }
        }
        volume {
          name = "tivodata"
          empty_dir {}
        }
        volume {
          name = "tmp"
          empty_dir {}
        }
      }
    }
  }
}
