import networkx as nwx
import DotGraphCreator as dgc
from CONSTANTS import ACTION_NODE, IS_ORIGINAL_ATTR, TYPE_ATTR

# reads in a graph from a Dot file.
# removing useless nodes
def read_graph(path):
    """
    Reads in the graph. Also pre-processes the nodes by adding is_original to the action nodes.

    Args:
        path (str): Path to the file.

    """
    graph = nwx.drawing.nx_pydot.read_dot(path)

    # bit of preprocessing clean up, this will need to be reviewed
    if graph.has_node(","):
        graph.remove_node(",")
    if graph.has_node("ros"):
        graph.remove_node("ros")

    for _, node in graph.nodes.items():
        # used for actionNode predicate
        if node[TYPE_ATTR] == ACTION_NODE:
            node[IS_ORIGINAL_ATTR] = True
    return graph


# outputs a graph to a pdf
def outputGraphViz(graph, filename, output_dir):
    """
    Ouputs the graph to a PNG file

    Args:
        graph (networkx graph): The graph.

    """
    graph_view = dgc.DotGraphCreator.create_dot_graph(graph)
    graph_view.render(
        directory="{}{}".format(output_dir, "/" if output_dir else ""),
        filename=filename,
        format="png",
    )
