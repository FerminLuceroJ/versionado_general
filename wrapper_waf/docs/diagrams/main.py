from diagrams import Diagram
from diagrams.aws.security import WAF

graph_attr = {
  "bgcolor": "transparent",
  "pad": "0.5",
  "size": "6"
}

node_attr = {
  "fontcolor": "#888888",
  "fontsize": "14pt"
}

with Diagram("", filename="main", show=False, direction="TB", graph_attr=graph_attr, node_attr=node_attr):
    WAF("Waf")
