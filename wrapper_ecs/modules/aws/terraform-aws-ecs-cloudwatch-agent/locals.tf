locals {

  base_resource_name  = var.name
  common_name_base    = var.common_name_base
  common_name_project = var.common_name_project

  vpc_name = var.vpc_name == null ? local.common_name_base : var.vpc_name

  container_environments = {
    "PROMETHEUS_CONFIG_CONTENT" : var.create_enable ? "${aws_ssm_parameter.prometheus_config[0].name}" : "",
    "CW_CONFIG_CONTENT" : var.create_enable ? "${aws_ssm_parameter.cw_agent_config[0].name}" : ""
  }

  ssm_parameter_prometheus_config_value = <<EOF
global:
  scrape_interval: 1m
  scrape_timeout: 10s
scrape_configs:
  - job_name: cwagent-ecs-file-sd-config
    sample_limit: 10000
    file_sd_configs:
      - files: [ "/tmp/cwagent_ecs_auto_sd.yaml" ]
EOF

  ssm_parameter_cw_agent_config_value = <<EOF
{
  "logs": {
    "metrics_collected": {
      "prometheus": {
        "prometheus_config_path": "env:PROMETHEUS_CONFIG_CONTENT",
        "ecs_service_discovery": {
          "sd_frequency": "1m",
          "sd_result_file": "/tmp/cwagent_ecs_auto_sd.yaml",
          "docker_label": {
          },
          "task_definition_list": [
            {
              "sd_job_name": "ecs-appmesh-colors",
              "sd_metrics_ports": "9901",
              "sd_task_definition_arn_pattern": ".*:task-definition/.*-ColorTeller-(white|red):[0-9]+",
              "sd_metrics_path": "/stats/prometheus"
            },
            {
              "sd_job_name": "ecs-appmesh-gateway",
              "sd_metrics_ports": "9901",
              "sd_task_definition_arn_pattern": ".*:task-definition/.*-ColorGateway:[0-9]+",
              "sd_metrics_path": "/stats/prometheus"
            }
          ]
        },
        "emf_processor": {
          "metric_declaration": [
            {
              "source_labels": ["container_name"],
              "label_matcher": "^envoy$",
              "dimensions": [["ClusterName","TaskDefinitionFamily"]],
              "metric_selectors": [
                "^envoy_http_downstream_rq_(total|xx)$",
                "^envoy_cluster_upstream_cx_(r|t)x_bytes_total$",
                "^envoy_cluster_membership_(healthy|total)$",
                "^envoy_server_memory_(allocated|heap_size)$",
                "^envoy_cluster_upstream_cx_(connect_timeout|destroy_local_with_active_rq)$",
                "^envoy_cluster_upstream_rq_(pending_failure_eject|pending_overflow|timeout|per_try_timeout|rx_reset|maintenance_mode)$",
                "^envoy_http_downstream_cx_destroy_remote_active_rq$",
                "^envoy_cluster_upstream_flow_control_(paused_reading_total|resumed_reading_total|backed_up_total|drained_total)$",
                "^envoy_cluster_upstream_rq_retry$",
                "^envoy_cluster_upstream_rq_retry_(success|overflow)$",
                "^envoy_server_(version|uptime|live)$"
              ]
            },
            {
              "source_labels": ["container_name"],
              "label_matcher": "^envoy$",
              "dimensions": [["ClusterName","TaskDefinitionFamily","envoy_http_conn_manager_prefix","envoy_response_code_class"]],
              "metric_selectors": [
                "^envoy_http_downstream_rq_xx$"
              ]
            },
            {
              "source_labels": ["Java_EMF_Metrics"],
              "label_matcher": "^true$",
              "dimensions": [["ClusterName","TaskDefinitionFamily"]],
              "metric_selectors": [
                "^jvm_threads_(current|daemon)$",
                "^jvm_classes_loaded$",
                "^java_lang_operatingsystem_(freephysicalmemorysize|totalphysicalmemorysize|freeswapspacesize|totalswapspacesize|systemcpuload|processcpuload|availableprocessors|openfiledescriptorcount)$",
                "^catalina_manager_(rejectedsessions|activesessions)$",
                "^jvm_gc_collection_seconds_(count|sum)$",
                "^catalina_globalrequestprocessor_(bytesreceived|bytessent|requestcount|errorcount|processingtime)$"
              ]
            },
            {
              "source_labels": ["Java_EMF_Metrics"],
              "label_matcher": "^true$",
              "dimensions": [["ClusterName","TaskDefinitionFamily","area"]],
              "metric_selectors": [
                "^jvm_memory_bytes_used$"
              ]
            },
            {
              "source_labels": ["Java_EMF_Metrics"],
              "label_matcher": "^true$",
              "dimensions": [["ClusterName","TaskDefinitionFamily","pool"]],
              "metric_selectors": [
                "^jvm_memory_pool_bytes_used$"
              ]
            },
            {
              "source_labels": ["Java_EMF_Metrics"],
              "label_matcher": "^true$",
              "dimensions": [["ClusterName","TaskGroup","TaskId"]],
              "metric_selectors": [
                "^jvm_threads_(current|daemon)$"
              ]
            },
            {
              "source_labels": ["Java_EMF_Metrics"],
              "label_matcher": "^true$",
              "dimensions": [["ClusterName","TaskGroup"]],
              "metric_selectors": [
                "^jvm_threads_(current|daemon)$"
              ]
            }
          ]
        }
      }
    },
    "force_flush_interval": 5
  }
}
EOF

}