# We only need Digraph
from graphviz import Digraph

from src.CONSTANTS import (
    ACTION_NODE,
    ALTERNATIVE_NODE,
    CONTEXT_NODE,
    DATA_ITEM_ATTR,
    DECISION_NODE,
    GOAL_NODE,
    IS_ALTERNATIVE,
    PARALLEL_NODE,
    RANGE_ATTR,
    TYPE_ATTR,
    FILLCOLOR,
    FIXEDSIZE,
    FONTCOLOR,
    HEIGHT,
    SHAPE,
    WIDTH,
)


class DotGraphCreator:
    """
    This class creates a graphviz dot graph from a NetworkX graph.

    Attributes:
        graph (NetworkXGraph): The graph to be converted to a dot graph.
        dot_graph (Digraph): The dot graph created from the NetworkX graph.
    """

    __FORMAT = {
        CONTEXT_NODE: {SHAPE: "oval", FILLCOLOR: "grey", FONTCOLOR: "black"},
        ACTION_NODE: {SHAPE: "box", FILLCOLOR: "deepskyblue", FONTCOLOR: "black"},
        DECISION_NODE: {
            SHAPE: "diamond",
            FILLCOLOR: "darkorange",
            FONTCOLOR: "black",
        },
        GOAL_NODE: {
            SHAPE: "circle",
            FILLCOLOR: "forestgreen",
            FONTCOLOR: "white",
            WIDTH: 0.1,
            "fontsize": 8,
        },
        PARALLEL_NODE: {
            SHAPE: "hexagon",
            FILLCOLOR: "gold",
            FONTCOLOR: "black",
            HEIGHT: 0.3,
            WIDTH: 0.3,
            FIXEDSIZE: True,
        },
        ALTERNATIVE_NODE: {
            SHAPE: "trapezium",
            HEIGHT: 0.3,
            WIDTH: 0.9,
            FIXEDSIZE: True,
            FILLCOLOR: "orange",
            FONTCOLOR: "black",
        },
    }

    @classmethod
    def __create_node_label(cls, id, node_props):
        """
        Creates a node label.

        Args:
            id: Node id.
            node_props: Node properties.

        Returns:
            Node label.
        """
        extra_label = (
            f"<br/>[cost={node_props['cost']}]"
            if node_props[TYPE_ATTR] == ACTION_NODE
            else ""
        )
        return f"<<b>{id}</b>{extra_label}>"

    @classmethod
    def __create_edge_label(cls, in_node_props, edge_props):
        """
        Creates the edge label.

        Args:
            in_node_props: The properties of the node the edge is coming from.
            edge_props: The properties of the edge.

        Returns:
            The edge label.
        """
        return (
            f"{in_node_props[DATA_ITEM_ATTR]}={edge_props[RANGE_ATTR]}"
            if in_node_props[TYPE_ATTR] == DECISION_NODE
            and not in_node_props.get(IS_ALTERNATIVE, False)
            else ""
        )

    @classmethod
    def create_dot_graph(cls, nx_graph):
        """
        Creates a graphviz dot graph from a NetworkX graph.

        Args:
            nx_graph: NetworkX graph.

        Returns:
            graphviz dot graph.
        """
        dot_graph = Digraph(name=nx_graph.graph["name"])
        for n in nx_graph.nodes:
            node_props = nx_graph.nodes[n]
            node_type = (
                ALTERNATIVE_NODE
                if node_props.get(IS_ALTERNATIVE)
                else node_props[TYPE_ATTR]
            )
            node_format = cls.__FORMAT[node_type]
            dot_graph.node(
                n,
                label=cls.__create_node_label(n, node_props),
                style="filled",
                shape=node_format[SHAPE],
                fillcolor=node_format[FILLCOLOR],
                fontcolor=node_format[FONTCOLOR],
            )

            for e in nx_graph.out_edges(n):
                edge_props = nx_graph[e[0]][e[1]][0]
                dot_graph.edge(
                    e[0], e[1], label=cls.__create_edge_label(node_props, edge_props)
                )
        return dot_graph
