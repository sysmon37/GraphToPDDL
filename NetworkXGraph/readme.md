# NetworkX Overview

# Read Dot file
````python
import networkx as nwx
dotGraph = nwx.drawing.nx_pydot.read_dot(path)
````

# Default Graph Value
````python
dotGraph.graph
"""
{'name': 'test_5', 
'graph': {'newrank': 'true', 'ranksep': '0.25'}, 
'node': {'shape': 'box', 'style': 'filled', 'fillcolor': 'deepskyblue', 'fontname': 'arial', 'fontsize': '10'}, 
'edge': {'fontname': 'arial', 'fontsize': '9'}
}
"""
````

# All Nodes
````python
dotGraph.nodes
````


# All Edges
````python
dotGraph.edges
````

# Get nodes attributes
````python
dotGraph.nodes.get("a1")
#{'label': '<<b>A1</b><br/>[cost=10]>'}

dotGraph.nodes.get("d1")["shape"]
#{'label': '<<b>D1</b>>', 'shape': 'oval', 'style': 'filled', 'fillcolor': 'grey'}

for node in nx_graph.nodes:
    print(node+ "=="+str(nx_graph.nodes[node]))
"""
d1=={'type': 'context'}
d2=={'type': 'context'}
t1=={'type': 'decision', 'dataItem': 'v1'}
t2=={'type': 'decision', 'dataItem': 'v2'}
t3=={'type': 'decision', 'dataItem': 'v3'}
a1=={'cost': '10', 'type': 'action'}
a2=={'cost': '10', 'type': 'action'}
a3=={'cost': '10', 'type': 'action'}
a7=={'cost': '10', 'type': 'action'}
a4=={'cost': '10', 'type': 'action'}
b1=={'cost': '10', 'type': 'action'}
b2=={'cost': '10', 'type': 'action'}
c1=={'cost': '10', 'type': 'action'}
c2=={'cost': '10', 'type': 'action'}
p1=={'type': 'parallel'}
p2=={'type': 'parallel'}
g1=={'type': 'goal'}
g2=={'type': 'goal'}
"""
````

# Get edges for a node
````python
dotGraph.in_edges("a1")
#[('t1', 'a1')]
````

# Get edges attributes
````python
dotGraph.get_edge_data('t1', 'a1') 
#{0: {'label': '<V1 = [0..4]>'}}
````

