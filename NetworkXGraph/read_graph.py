from io import TextIOWrapper
from graphviz import Digraph
from graphviz.files import File  # We only need Digraph
import networkx as nwx
import matplotlib.pyplot as plt
import DotGraphCreator as dgc

test_path = "testcase-5.dot"
test_path2 = "testcase-afib.dot"

# return a list of nodes of the given type
def get_type_nodes(graph, node_type):
    return [node for node, attr in graph.nodes.items() if attr["type"] == node_type]


# reads in a graph from a Dot file.
# removing useless nodes
def read_graph(path):
    graph = nwx.drawing.nx_pydot.read_dot(path)
    # bit of preprocessing clean up
    if graph.has_node(","):
        graph.remove_node(",")
    if graph.has_node("ros"):
        graph.remove_node("ros")
    # TODO - rename nodes between parallel nodes with prefix?
    for name, node in graph.nodes.items():
        # used for actionNode predicate
        # might not be needed onde we start working with RO... TBD
        if node["type"] == "action":
            node["is_original"] = True
    # TODO - add attributes to nodes between parallel nodes
    # update_between_parallel_ndoes(graph, "p1", "p2")
    return graph


# outputs a graph to a pdf
def outputGraphViz(graph):
    graph_view = dgc.DotGraphCreator.create_dot_graph(graph)
    graph_view.view()


def write_objects(graph: nwx.DiGraph, file: TextIOWrapper):
    # might be able to refactor this into a function that returns {diseases, node, revId} once we'll add RO
    disease = get_type_nodes(graph, "context")
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
    # decision branching min/max
    write_decision_branch(graph, file)
    file.write("\n")

    # patient value - NOT NOW
    # noPreviousDecision- ???
    # predecessorNode
    init_nodes = get_type_nodes(graph, "context")
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
            if node_type == "context":
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

        # originalAction - added is_original to action nodes
        if attributes.get("is_original", False):
            original_node.append("\t(originalAction {})\n".format(name))
    file.write("".join(predecessor))
    file.write("\n")
    file.write("".join(nodes))
    file.write("\n")
    file.write("".join(original_node))

    # revisionAction - NOT NOW
    # revision flag - NOT NOW
    # tentativeGoalCount - ???
    # numgoals
    file.write("\n")
    file.write("\t(= (numGoals) {})\n".format(len(get_type_nodes(graph, "goal"))))

    # nodeCost - ask with afib example for different costs
    file.write("\n")
    write_node_cost(graph, file)

    # total-cost - ??
    file.write("\n")
    file.write("\t(= (total-cost) 0)\n")
    file.write(")\n")


def write_decision_branch(graph, file):
    decision_nodes = get_type_nodes(graph, "decision")
    for node in decision_nodes:
        for _, out_edge in graph.out_edges(node):
            lower, upper = graph[node][out_edge][0]["range"].split("..")
            file.write(
                "\t(= (decisionBranchMin {} {} {}) {})\n".format(
                    find_init_node(graph, node), node, out_edge, lower
                )
            )
            file.write(
                "\t(= (decisionBranchMax {} {} {}) {})\n".format(
                    find_init_node(graph, node), node, out_edge, upper
                )
            )


def update_between_parallel_ndoes(graph, start_node, end_node):
    if graph.nodes[start_node]["type"] == "action":
        graph.nodes[start_node]["is_in_parallel"] = True
    for _, node in graph.out_edges(start_node):
        if node != end_node:
            update_between_parallel_ndoes(graph, node, end_node)


def write_node_cost(graph, file):
    init_nodes = get_type_nodes(graph, "context")
    for node, attr in graph.nodes.items():
        if node not in init_nodes:
            file.write("\t(= (nodesCost {}) {})\n".format(node, attr.get("cost", 0)))


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


def write_metric(graph, file):
    file.write("(:metric minimize (total-cost))\n)\n")


def outputPDDL(graph, problem_name, domain_name):
    with open("problem.pddl", "w") as pddl:
        # define
        pddl.write(("(define (problem {})\n").format(problem_name))
        pddl.write(("\t(:domain  {})\n").format(domain_name))

        # objects
        write_objects(graph, pddl)

        # :init
        pddl.write("\n")
        write_initial_state(graph, pddl)

        # :goal
        pddl.write("\n")
        write_goal(graph, pddl)

        # :metric
        pddl.write("\n")
        write_metric(graph, pddl)
        pddl.write(")")
        pddl.close()


def run(path="../UseCases/AGFigures/testcase-5.dot"):
    graph = read_graph(path)
    outputPDDL(graph, "problem-test", "domain_test")
    # outputGraphViz(graph)


if __name__ == "__main__":
    run("../UseCases/AGFigures/testcase-5-rev.dot")
