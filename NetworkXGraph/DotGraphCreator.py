from graphviz import Digraph  # We only need Digraph


class DotGraphCreator:
    """
    This class creates a graphviz dot graph from a NetworkX graph.

    Attributes:
        graph (NetworkXGraph): The graph to be converted to a dot graph.
        dot_graph (Digraph): The dot graph created from the NetworkX graph.
    """

    __FORMAT = {
        "context": {"shape": "oval", "fillcolor": "grey", "fontcolor": "black"},
        "action": {"shape": "box", "fillcolor": "deepskyblue", "fontcolor": "black"},
        "decision": {
            "shape": "diamond",
            "fillcolor": "darkorange",
            "fontcolor": "black",
        },
        "goal": {
            "shape": "circle",
            "fillcolor": "forestgreen",
            "fontcolor": "white",
            "width": 0.1,
            "fontsize": 8,
        },
        "parallel": {
            "shape": "hexagon",
            "fillcolor": "gold",
            "fontcolor": "black",
            "height": 0.3,
            "width": 0.3,
            "fixedsize": True,
        },
        "alternative": {
            "shape": "trapezium",
            "height": 0.3,
            "width": 0.9,
            "fixedsize": True,
            "fillcolor": "orange",
            "fontcolor": "black",
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
            if node_props["type"] == "action"
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
            f"{in_node_props['dataItem']}={edge_props['range']}"
            if in_node_props["type"] == "decision"
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
            node_format = cls.__FORMAT[node_props["type"]]
            dot_graph.node(
                n,
                label=cls.__create_node_label(n, node_props),
                style="filled",
                shape=node_format["shape"],
                fillcolor=node_format["fillcolor"],
                fontcolor=node_format["fontcolor"],
            )

            for e in nx_graph.out_edges(n):
                edge_props = nx_graph[e[0]][e[1]][0]
                dot_graph.edge(
                    e[0], e[1], label=cls.__create_edge_label(
                        node_props, edge_props)
                )
        return dot_graph
