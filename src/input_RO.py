import json
from operator import itemgetter

from CONSTANTS import (
    ACTION_NODE,
    DECISION_NODE,
    DELETE_OPERATION,
    EDGE_TO_SUCCESSORS,
    EDGE_TO_SUCCESSORS_ATTR,
    EXISTRING_NDOE,
    IS_ORIGINAL_ATTR,
    NEW_NODES,
    OPERATIONS,
    PREDECESSORS,
    RANGE_ATTR,
    REPLACE_OPERATION,
    SUCCESSORS,
    TRIGGER,
    TYPE_ATTR,
)


def read_JSON(path):
    """
    Reads a JSON file and returns its content.

    Args:
        path (str): Path to the file.

    Returns:
        json: JSON object
    """
    with open(path) as file:
        obj = json.load(file)
        file.close()
    return obj


def update_graph_with_ROs(graph, ros):
    """
    Excutes the operations (replace, delete, add) of every revision operators.
    Args:
        graph (networkx graph): The graph.
        ros (list): List of JSON like object.
    """
    for ro in ros:
        id, trigger, operations = itemgetter("id", TRIGGER, OPERATIONS)(ro)
        operations = ro[OPERATIONS]
        for op in operations:
            type = op[TYPE_ATTR]
            if type == REPLACE_OPERATION:
                replace_operation(graph, id, trigger, op)
            elif type == DELETE_OPERATION:
                delete_operation(graph, op)
            else:
                add_operation(graph, id, trigger, op)


def add_all_new_nodes(graph, id_ro, trigger, operation):
    """
    Add a list of new nodes with some attributes. These nodes do not have any edges after the execution of this function.

    Use 'add_all_new_edges' to add the respectives edges.

    Args:
        graph (networkx graph): The graph.
        id_ro (str): The ID of the revision operator.
        trigger (list): List of triggering nodes.
        operation (object): The operation object.
    """
    edge_to_successors = []
    for node in operation[NEW_NODES]:
        # taking node id and the rest of its attributes
        node_copy = {**node}
        new_node_id = node_copy["id"]
        node_type = node_copy[TYPE_ATTR]

        # if the current node needs to connect to the successors of the 'existing node'
        if node_copy.get(EDGE_TO_SUCCESSORS, False):
            edge_to_successors.append(
                {"node": new_node_id, **node_copy.get(EDGE_TO_SUCCESSORS_ATTR, {})}
            )

        if node_type == ACTION_NODE:
            node_copy[IS_ORIGINAL_ATTR] = False

        node_copy.pop("id", None)
        node_copy.pop(TYPE_ATTR, None)
        node_copy.pop(PREDECESSORS, None)
        node_copy.pop(EDGE_TO_SUCCESSORS, None)

        # adding it to the graph
        # Currently assuming the added nodes are all actionNode
        graph.add_node(
            new_node_id, type=node_type, idRO=id_ro, trigger=trigger, **node_copy
        )
    return edge_to_successors


def add_all_new_edges(graph, operation, edge_to_successors):
    """
    Add all the edges from the operation object.

    Nodes related to these edges must be added to the graph prior to this function call.

    Use 'add_all_new_nodes' to add the respectives nodes before calling this function.


    Args:
        graph (networkx graph): The graph.
        id_ro (str): The ID of the revision operator.
        trigger (list): List of triggering nodes.
        operation (object): The operation object.
    """
    existing_node = operation[EXISTRING_NDOE]

    for node in operation[NEW_NODES]:
        node_copy = {**node}
        new_node_id = node_copy["id"]

        predecessor_list = node_copy.get(
            PREDECESSORS, list(graph.predecessors(existing_node))
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


def replace_operation(graph, id_ro, trigger, operation):
    """
    Replace operation inserts a sequence of new nodes.

    This function is a 2-steps process. First, we add all the nodes to be added. Secondly, we add all the edges.

    This allows the RO file to have the nodes in any particular order.

    Args:
        graph (networkx graph): The graph.
        id_ro (str): The ID of the revision operator.
        trigger (list): List of triggering nodes.
        operation (object): The operation object
    """
    edge_to_successors = add_all_new_nodes(graph, id_ro, trigger, operation)
    add_all_new_edges(graph, operation, edge_to_successors)


def delete_operation(graph, operation):
    """
    Deletes a node. Links its predecessors and successors together.

    Args:
        graph (networkx graph): The graph.
        operation (str): The operation object
    """
    node_to_delete = operation[EXISTRING_NDOE]
    predecessors = graph.predecessors(node_to_delete)
    successors = graph.successors(node_to_delete)

    for pred in predecessors:
        for succ in successors:
            pred_edge_data = graph.get_edge_data(pred, node_to_delete)[0]
            succ_edge_data = graph.get_edge_data(node_to_delete, succ)[0]

            if not graph.has_edge(pred, succ):
                graph.add_edge(pred, succ, **pred_edge_data, **succ_edge_data)


def add_operation(graph, idRO, trigger, operation):
    """
    Add operation inserts a node(s) between a list of predeccessors and successors.

    Args:
        graph (networkx graph): The graph.
        idRO (str): The ID of the revision operator.
        trigger (list): List of triggering nodes.
        operation (str): The operation object
    """

    addedNodes = operation[NEW_NODES]

    # for predecessor in predecessors:
    #     for successor in successors:
    for node in addedNodes:
        # taking node id and the rest of its attributes
        node_copy = {**node}  # cost ...
        new_node_id = node_copy["id"]

        node_type = node_copy[TYPE_ATTR]
        del node_copy["id"]
        del node_copy[TYPE_ATTR]

        # Predecessors and successors are lists of dictionaries
        predecessors_list = node_copy.get(PREDECESSORS, None)
        successors_list = node_copy.get(SUCCESSORS, None)
        node_copy.pop(PREDECESSORS, None)
        node_copy.pop(SUCCESSORS, None)

        # disease/goal case
        if not predecessors_list:
            predecessors_list = ["disease"]
        if not successors_list:
            successors_list = ["goal"]

        for predecessor in predecessors_list:
            for successor in successors_list:
                # adding it to the graph
                # Currently assuming the added nodes are all actionNode

                graph.add_node(
                    new_node_id,
                    type=node_type,
                    is_original=False,
                    idRO=idRO,
                    trigger=trigger,
                    **node_copy
                )

                # Get nodeId of predecessor and successor
                if not predecessor == "disease":
                    pred = {**predecessor}
                    predecessor_node = pred.get("nodeId", None)
                    pred.pop("nodeId", None)
                if not successor == "goal":
                    succ = {**successor}
                    successor_node = succ.get("nodeId", None)
                    succ.pop("nodeId", None)

                # Get range of predecessor and successor
                if not predecessor == "disease":
                    predecessor_range = pred.get(RANGE_ATTR, None)
                    pred.pop(RANGE_ATTR, None)
                if not successor == "goal":
                    successor_range = succ.get(RANGE_ATTR, None)
                    succ.pop(RANGE_ATTR, None)

                # Case where the Predecessor node and successor node are adjecent
                # if graph.has_edge(predecessor_node, successor_node) :
                # Adding the edge between the new node and the predecessor with the edge data
                # We only want one edge between the predecessor and the new node
                if not graph.has_edge(predecessor_node, new_node_id):
                    if not predecessor == "disease":

                        if (
                            graph.has_edge(predecessor_node, successor_node)
                            and not predecessor_range
                        ):  # if the range is not specified from the predecessor
                            graph.add_edge(
                                predecessor_node,
                                new_node_id,
                                **graph.get_edge_data(predecessor_node, successor_node)[
                                    0
                                ]
                            )
                        else:
                            graph.add_edge(
                                predecessor_node,
                                new_node_id,
                                range=predecessor_range,
                                **pred
                            )

                # We only want one edge between the new node and the successor
                if not graph.has_edge(new_node_id, successor_node):
                    if not successor == "goal":
                        if node_type == DECISION_NODE:
                            #     for ranges in node_range:
                            #         if ranges.get(SUCCESSORS, None) == successor_node:
                            graph.add_edge(
                                new_node_id,
                                successor_node,
                                range=successor_range,
                                **succ
                            )
                        else:
                            graph.add_edge(new_node_id, successor_node, **succ)
