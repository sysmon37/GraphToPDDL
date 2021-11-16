import json
from operator import itemgetter


def read_RO(path):
    """
    Reads the revision operator file. The file MUST be JSON format.

    Args:
        path (str): Path to the file.

    Returns:
        json: JSON object
    """
    with open(path) as file:
        ros = json.load(file)
        file.close()
    return ros


def update_graph_with_ROs(graph, ros):
    """
    Excutes the operations (replace, delete, add) of every revision operators.

    Args:
        graph (networkx graph): The graph.
        ros (list): List of JSON like object.
    """
    for ro in ros:
        id, trigger, operations = itemgetter("id", "trigger", "operations")(ro)
        operations = ro["operations"]
        for op in operations:
            type = op["type"]
            if type == "replace":
                replace_operation(graph, id, trigger, op)
            elif type == "delete":
                delete_operation(graph, op)
            else:
                add_action(graph, id, trigger, op)


def replace_operation(graph, id_ro, trigger, operation):
    """
    Replace operation inserts a sequence of new nodes. The first node of the sequence is a sibling of the node to 'replace' with the same edge attributs to the predecessor.

    Args:
        graph (networkx graph): The graph.
        id_ro (str): The ID of the revision operator.
        trigger (list): List of triggering nodes.
        operation (str): The operation object
    """
    existing_node = operation["existingNode"]

    edge_to_successors = []
    for node in operation["newNodes"]:
        # taking node id and the rest of its attributes
        node_copy = {**node}
        new_node_id = node_copy["id"]
        node_type = node_copy["type"]

        # if the current node needs to connect to the successors of the 'existing node'
        if node_copy.get("edgeToSuccessors", False):
            edge_to_successors.append(
                {"node": new_node_id, **node_copy.get("edgeToSuccessorsAttr", {})}
            )

        # usually is 1 node
        predecessor_list = node_copy.get(
            "predecessors", list(graph.predecessors(existing_node))
        )
        if node_type == "action":
            node_copy["is_original"] = False

        node_copy.pop("id", None)
        node_copy.pop("type", None)
        node_copy.pop("predecessors", None)
        node_copy.pop("edgeToSuccessors", None)

        # adding it to the graph
        # Currently assuming the added nodes are all actionNode
        graph.add_node(
            new_node_id, type=node_type, idRO=id_ro, trigger=trigger, **node_copy
        )
        for pred in predecessor_list:
            if isinstance(pred, str):
                pred = {"nodeId": pred}
            pred_node = pred["nodeId"]
            pred.pop("nodeId", None)
            # copying the edge data if any but only to the first new node
            edge_data = graph.get_edge_data(pred_node, existing_node)
            edge_data = edge_data[0] if edge_data else {}
            if not graph.has_edge(pred_node, new_node_id):
                graph.add_edge(pred_node, new_node_id, **pred, **edge_data)

    current_existing_nodes_successors = list(graph.successors(existing_node))
    for edge in edge_to_successors:
        node = edge["node"]
        edge.pop("node", None)
        for succ in current_existing_nodes_successors:
            if not graph.has_edge(node, succ):
                # need one last edge from the last added node to the same node 'Existing_node' is pointing too
                graph.add_edge(node, succ, **edge)


def delete_operation(graph, operation):
    """
    Deletes a node. Links its predecessors and successors together.

    Args:
        graph (networkx graph): The graph.
        operation (str): The operation object
    """
    node_to_delete = operation["existingNode"]
    predecessors = graph.predecessors(node_to_delete)
    successors = graph.successors(node_to_delete)

    for pred in predecessors:
        for succ in successors:
            pred_edge_data = graph.get_edge_data(pred, node_to_delete)[0]
            succ_edge_data = graph.get_edge_data(node_to_delete, succ)[0]

            if not graph.has_edge(pred, succ):
                graph.add_edge(pred, succ, **pred_edge_data, **succ_edge_data)


def add_action(graph, idRO, trigger, operation):
    """
    Add operation inserts a node(s) between a list of predeccessors and successors.

    Args:
        graph (networkx graph): The graph.
        idRO (str): The ID of the revision operator.
        trigger (list): List of triggering nodes.
        operation (str): The operation object
    """
    predecessors = operation["predecessors"]
    successors = operation["successors"]

    addedNodes = operation["newNodes"]

    for predecessor in predecessors:
        for successor in successors:
            for node in addedNodes:
                # taking node id and the rest of its attributes
                node_copy = {**node}
                new_node_id = node_copy["id"]
                del node_copy["id"]

                # adding it to the graph
                # Currently assuming the added nodes are all actionNode
                graph.add_node(
                    new_node_id,
                    type="action",
                    is_original=False,
                    idRO=idRO,
                    trigger=trigger,
                    **node_copy
                )
                # print(graph.get_edge_data(predecessor, successor)[0])
                # nwx.add_path(graph,[predecessor, new_node_id, successor])

                # Case where the Predecessor node and successor node are adjecent
                if graph.has_edge(predecessor, successor):
                    # Adding the edge between the new node and the predecessor with the edge data
                    # We only want one edge between the predecessor and the new node
                    if not graph.has_edge(predecessor, new_node_id):
                        graph.add_edge(
                            predecessor,
                            new_node_id,
                            **graph.get_edge_data(predecessor, successor)[0]
                        )

                    # We need to remove the edges between the predecessor and the successor
                    graph.remove_edge(predecessor, successor)

                # Case where the predecessor node is not adjacent to the successor node
                else:
                    tmpSuccessors = list(graph.successors(predecessor))

                    for tmpSuccessor in tmpSuccessors:
                        # What range data do we want to copy/overlap?
                        # Using the first edge data for now
                        if graph.get_edge_data(predecessor, tmpSuccessor):
                            tmpData = graph.get_edge_data(predecessor, tmpSuccessor)[0]
                            # We only want one edge between the predecessor and the new node
                            if not graph.has_edge(predecessor, new_node_id):
                                graph.add_edge(predecessor, new_node_id, **tmpData)
                            break
                # print(graph.edges(new_node_id))
            # Adding the edge between the new node and the successor with the edge data

            # We only want one edge between the new node and the successor
            if not graph.has_edge(new_node_id, successor):
                graph.add_edge(new_node_id, successor)
