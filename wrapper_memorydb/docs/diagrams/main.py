from diagrams import Cluster, Diagram
from diagrams.aws.database import ElastiCache

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
  
  ElastiCache("ElastiCache")