from io import BufferedWriter, TextIOWrapper
from graphviz import Digraph
from graphviz.files import File  # We only need Digraph
import networkx as nwx
import matplotlib.pyplot as plt
from networkx.algorithms.shortest_paths.unweighted import predecessor
from networkx.classes.reportviews import OutMultiEdgeDataView
from networkx.generators.social import les_miserables_graph

test_path = "testcase-5.dot"
test_path2 = "testcase-afib.dot"
POSSIBLE_NODES = {
    "circle": "goal",
    "oval": "context",
    "diamond": "decision",
    "hexagon": "parallele",
    "trapezium": "decision",
}
# reads in a graph from a Dot file.
# removing useless nodes


def read_graph(path):
    graph = nwx.drawing.nx_pydot.read_dot(path)

    # bit of preprocessing clean up
    if graph.has_node(","):
        graph.remove_node(",")
    if graph.has_node("ros"):
        graph.remove_node("ros")
    # TODO - rename nodes between parallel nodes with prefix
    for name, node in graph.nodes.items():
        node_type = POSSIBLE_NODES.get(node.get("shape", ""), "action")
        node["type"] = node_type
        # used for actionNode predicate
        # might not be needed onde we start working with RO... TBD
        if node_type == "action":
            node["is_original"] = True
    # handle_parallel(graph)
    return graph


# def handle_parallel(graph):
#     inital_nodes= []
#     for node in graph.nodes:
#         if not len(list(graph.in_edges(node))):
#             inital_nodes.append(node)

# def find_parallel_section(graph):
#     inital_nodes= []
#     for node in graph.nodes:
#         if not len(list(graph.in_edges(node))):
#             inital_nodes.append(node)
#     parallel = []
#     for node in inital_nodes:

# outputs a graph to a pdf
def outputGraphViz(graph):
    graph_name = graph.graph["name"]
    graph_view = Digraph(name=graph_name)

    for node in graph.nodes:
        label = graph.nodes[node].get("label", "No Label")
        shape = graph.nodes[node].get("shape", graph.graph["node"]["shape"])
        fillcolor = graph.nodes[node].get("fillcolor", graph.graph["node"]["fillcolor"])
        graph_view.node(
            node,
            label=label,
            shape=shape,
            style="filled",
            fillcolor=fillcolor,
        )  # Add label,shape,color to the graph if it exist

        # Add Edges to the graph
        for edge in graph.in_edges(node):
            in_edge, out_edge = edge
            label = graph.get_edge_data(in_edge, out_edge)[0].get("label", "")
            graph_view.edge(
                in_edge, out_edge, label=label
            )  # Add label to the edge if it exist
    graph_view.view()


def write_objects(graph: nwx.DiGraph, file: TextIOWrapper):
    # might be able to refactor this into a function that returns {diseases, node, revId} once we'll add RO
    disease = [node for node in graph.nodes if graph.nodes[node]["type"] == "context"]
    nodes = [node for node in graph.nodes if graph.nodes[node]["type"] != "context"]
    file.write("(:objects {} - disease\n".format(" ".join(disease)))
    file.write("\t" * 3 + "{} - node\n".format(" ".join(nodes)))
    file.write(")\n")


# find a goalNode recursivly for a given start node
# goal nodes MUST NOT have out_edges.
# Need to make sure the edge from goal node to ros is removed
def find_goal_node(graph, start_node):
    out_edges = graph.out_edges(start_node)
    if len(out_edges):
        return find_goal_node(graph, list(out_edges)[0][1])
    return start_node


# find a goalNode recursivly for a given start node
def find_init_node(graph, start_node):
    in_edges = graph.in_edges(start_node)
    if len(in_edges):
        return find_init_node(graph, list(in_edges)[0][0])
    return start_node


def write_initial_state(graph: nwx.DiGraph, file: TextIOWrapper):
    file.write("(:init ")
    # decision branching min/max - LATER
    # patient value - NOT NOW
    # noPreviousDecision- ???
    # predecessorNode
    init_nodes = [
        node for node in graph.nodes if graph.nodes[node]["type"] == "context"
    ]

    # for edge in graph.edges:
    #     from_edge, to_edge, *_ = edge
    #     if from_edge in init_nodes:
    #         file.write("\t(initialNode {} {})\n".format(from_edge, to_edge))
    #         file.write(
    #             "\t(goalNode {} {})\n".format(from_edge, find_goal_node(graph, to_edge))
    #         )
    #         continue
    #     file.write("\t(predecessorNode {} {})\n".format(from_edge, to_edge))
    # file.write("\n")
    # node types
    nodes = []
    predecessor = []
    original_node = []
    # TODO - work on parrallel Node
    for name, attributes in graph.nodes.items():
        node_type = attributes["type"]
        if node_type not in ["context", "goal"]:
            nodes.append("\t({}Node {})\n".format(node_type, name))
        else:
            if len(graph.in_edges(name)) == 0 and node_type == "context":
                file.write(
                    "\t(initialNode {} {})\n".format(
                        name, list(graph.out_edges(name))[0][1]
                    )
                )
                file.write(
                    "\t(goalNode {} {})\n".format(name, find_goal_node(graph, name))
                )

        for pred in graph.predecessors(name):
            if pred not in init_nodes:
                predecessor.append("\t(predecessorNode {} {})\n".format(pred, name))

        if attributes.get("is_original", False):
            original_node.append("\t(originalAction {})\n".format(name))
    file.write("".join(predecessor))
    file.write("\n")
    file.write("".join(nodes))
    file.write("\n")
    file.write("".join(original_node))

    # originalAction - added is_original to action nodes
    # revisionAction - NOT NOW
    # revision flag - NOT NOW
    # nodeCost - ask with afib example for different costs
    # numgoals

    file.write(")\n")


def write_goal(graph, file):
    goal_nodes = [node for node in graph.nodes if graph.nodes[node]["type"] == "goal"]
    file.write("(:goal ")
    if len(goal_nodes) > 1:
        file.write("(and")
    for node in goal_nodes:
        find_init_node(graph, node)
        file.write(
            "\t(treatmentPlanReady {} {})\n".format(find_init_node(graph, node), node)
        )
    file.write(")\n")


def outputPDDL(graph, problem_name, domain_name):
    with open("problem.pddl", "w") as pddl:
        pddl.write(("(define (problem {})\n").format(problem_name))
        pddl.write(("\t(:domain  {})\n").format(domain_name))
        write_objects(graph, pddl)
        write_initial_state(graph, pddl)
        # :goal
        write_goal(graph, pddl)
        # :metric
        pddl.write(")")
        pddl.close()


def run(path="../UseCases/AGFigures/testcase-1.dot"):
    graph = read_graph(path)

    outputPDDL(graph, "problem-test", "domain_test")
    # outputGraphViz(graph)


if __name__ == "__main__":
    run()
