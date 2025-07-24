from diagrams import Cluster, Diagram

from diagrams.aws.compute import ElasticContainerService, ECS
from diagrams.aws.management import Cloudwatch
from diagrams.aws.compute import Fargate
from diagrams.aws.compute import ApplicationAutoScaling, AutoScaling

graph_attr = {
  "bgcolor": "transparent",
  "pad": "0.5",
  "size": "6"
}

cluster_attr = {
  "bgcolor": "transparent",
  "pad": "0.5",
  "size": "6",
  "fontcolor": "#888888",
  "labeljust":"c"
}

node_attr = {
  "fontcolor": "#888888",
  "fontsize": "14pt"
}

with Diagram("", filename="main", show=False, direction="TB", graph_attr=graph_attr, node_attr=node_attr):
  ECS = ElasticContainerService("ECS Cluster")
  with Cluster("Monitoring and Logging", graph_attr=cluster_attr):
    Insights = Cloudwatch("Container Insights")
    Logs = Cloudwatch("Cluster Logs")
  with Cluster("Capacity Providers", graph_attr=cluster_attr):
    Fargate = Fargate("Fargate")
    EC2 = AutoScaling("Autoscaling")

  Fargate >> ECS >> Logs
