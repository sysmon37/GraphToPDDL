import networkx as nwx
import DotGraphCreator as dgc

# reads in a graph from a Dot file.
# removing useless nodes
def read_graph(path):
    graph = nwx.drawing.nx_pydot.read_dot(path)

    # bit of preprocessing clean up, this will need to be reviewed
    if graph.has_node(","):
        graph.remove_node(",")
    if graph.has_node("ros"):
        graph.remove_node("ros")

    for _, node in graph.nodes.items():
        # used for actionNode predicate
        if node["type"] == "action":
            node["is_original"] = True
    return graph


# outputs a graph to a pdf
def outputGraphViz(graph, filename="problem"):
    graph_view = dgc.DotGraphCreator.create_dot_graph(graph)
    graph_view.render(filename=filename, format="png")
