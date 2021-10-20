from graphviz import Digraph  # We only need Digraph


class DotGraphCreator:
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
    }

    @classmethod
    def __create_node_label(cls, id, node_props):
        extra_label = (
            f"<br/>[cost={node_props['cost']}]"
            if node_props["type"] == "action"
            else ""
        )
        return f"<<b>{id}</b>{extra_label}>"

    @classmethod
    def __create_edge_label(cls, in_node_props, edge_props):
        return (
            f"{in_node_props['dataItem']}={edge_props['range']}"
            if in_node_props["type"] == "decision"
            else ""
        )

    @classmethod
    def create_dot_graph(cls, nx_graph):
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
                    e[0], e[1], label=cls.__create_edge_label(node_props, edge_props)
                )
        return dot_graph
