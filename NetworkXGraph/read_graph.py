import networkx as nwx
import matplotlib.pyplot as plt
from networkx.generators.social import les_miserables_graph

path = "testcase-5.dot"
path2 = "testcase-afib.dot"
dotGraph = nwx.drawing.nx_pydot.read_dot(path)

#print(type(dotGraph))
#print(dotGraph.graph)
"""
{'name': 'test_5', 
'graph': {'newrank': 'true', 'ranksep': '0.25'}, 
'node': {'shape': 'box', 'style': 'filled', 'fillcolor': 'deepskyblue', 'fontname': 'arial', 'fontsize': '10'}, 
'edge': {'fontname': 'arial', 'fontsize': '9'}
}
"""
#print(dotGraph.nodes)
"""
['d1', 'd2', 't1', 't2', 't3', 'a1', 'a2', 'a3', 'a7', 'a4', 'b1', 'b2', 'c1', 'c2', 'p1', 'p2', 'g1', 'g2', 'ros', ',']
"""
#print(dotGraph.edges)
"""
[('d1', 't1', 0), ('d2', 'a4', 0), ('t1', 'a1', 0), ('t1', 'a2', 0), ('t2', 'g1', 0), ('t2', 'a3', 0), ('t3', 'a7', 0), ('t3', 'g2', 0), ('a1', 'p1', 0), ('a2', 'p1', 0), ('a3', 'g1', 0), ('a7', 'g2', 0), ('a4', 't3', 0), ('b1', 'b2', 0), ('b2', 'p2', 0), ('c1', 'c2', 0), ('c2', 'p2', 0), ('p1', 'b1', 0), ('p1', 'c1', 0), ('p2', 't2', 0), ('g1', 'ros', 0), ('g2', 'ros', 0), (',', 'p1', 0), (',', 'ros', 0)]

"""
#print(dotGraph.adj)
#'data', 'get', 'isdisjoint', 'items', 'keys', 'values']
print(dotGraph.nodes.get("a1")) #{'label': '<<b>A1</b><br/>[cost=10]>'} use default shape!!!
print(dotGraph.nodes.get("p1"))#{'label': '<<b>D1</b>>', 'shape': 'oval', 'style': 'filled', 'fillcolor': 'grey'}
print(dotGraph.in_edges("a1")) #[('t1', 'a1')]
print(dotGraph.get_edge_data('t1', 'a1'))#[0]["label"]) #{0: {'label': '<V1 = [0..4]>'}}


# nwx.draw(dotGraph,with_labels = True)
# plt.savefig("filename.png")


#Testing
from graphviz import Digraph # We only need Digraph
name = dotGraph.graph["name"]
g = Digraph(name=name)

# preprocessing
# print(dotGraph.edges)
dotGraph.remove_node(",")
dotGraph.remove_node("ros")
# print(dotGraph.edges)

for n in dotGraph.nodes:
    # print("node")
    print(n)

    g.node(n, 
    label=dotGraph.nodes.get(n)["label"], 
    shape=dotGraph.nodes.get(n).get('shape', dotGraph.graph["node"]["shape"]),
    style='filled',fillcolor=dotGraph.nodes.get(n).get('fillcolor', dotGraph.graph["node"]["fillcolor"])) # Add label,shape,color to the graph if it exist

    # Add Edges to the graph
    for e in dotGraph.in_edges(n):
        # print("out")

        #print(dotGraph.get_edge_data(e[0], e[1])[0])
        g.edge(e[0], e[1], 
        label=dotGraph.get_edge_data(e[0], e[1])[0].get("label","")) # Add label to the edge if it exist



g.view()

print("Graph View for", name)