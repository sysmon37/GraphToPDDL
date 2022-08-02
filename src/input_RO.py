import json
from operator import itemgetter

from src.CONSTANTS import (
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
    SEQUENCE, THEN, OR,
    SUCCESSORS,
    TRIGGER,
    TYPE_ATTR,
    TRIGGERCONDITION,
    OFFSET,
    OFFSET_NODE,
    START_TIME_REF,
    START_TIME_WHICH,
    START_TIME_CHANGE,
    END_TIME_REF,
    END_TIME_WHICH,
    END_TIME_CHANGE,
    START,
    END
)

from src.matching import match_terms
from src.utils import get_type_nodes


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
    Executes the operations (replace, delete, add) of every revision operators.
    Args:
        graph (networkx graph): The graph.
        ros (list): List of JSON like object.
    """
    for ro in ros:
        id, trigger, triggercondition, operations = itemgetter("id", TRIGGER, TRIGGERCONDITION, OPERATIONS)(ro)

        #If no triggering conditions are specified then continue with RO as is.
        #If a triggering condition is specified then check if the condition is met.
        #If the condition is met, proceed with RO. Otherwise do not apply the RO.

        for condition in triggercondition:
            if condition == "":
                break
            else:
                for op in operations:
                    if check_trigger_condition(trigger, graph, op):
                        break
                    else:
                        return
        #print(condition)


        operations = ro[OPERATIONS]
        for op in operations:
            type = op[TYPE_ATTR]
            if type == REPLACE_OPERATION:
                replace_operation(graph, id, trigger, op)
            elif type == DELETE_OPERATION:
                delete_operation(graph, op)
            else:
                add_operation(graph, id, trigger, op)



def check_trigger_condition(trigger, graph, operation):
    #Check if triggering condition is met.

    v0 = trigger[0]
    v1 = trigger[1]

    node0 = graph.nodes[v0]
    node1 = graph.nodes[v1]

    node0_start = int(node0['startTimeCost']);
    node0_end = int(node0['endTimeCost']);
    node1_start = int(node1['startTimeCost']);
    node1_end = int(node1['endTimeCost']);

    if(((node0_start <= node1_start) and (node0_end >= node1_start)) or
        ((node0_start <= node1_end) and (node0_end >= node1_end)) or
        ((node1_start <= node0_start) and (node1_end >= node0_start)) or
        ((node1_start <= node0_end) and (node1_end >= node0_end))):

        print('overlap!')

        #Typically we need to modify action node durations when an overlap exists.
        for node in operation[NEW_NODES]:
            if node['durationCost'] == "":

                #Compute start and end times.
                sreftime = 0
                ereftime = 0
                stime = 0
                etime = 0
                echange = int(node[END_TIME_CHANGE])
                schange = int(node[START_TIME_CHANGE])

                #Compute start time
                if node[START_TIME_REF] == EXISTRING_NDOE and node[START_TIME_WHICH] == START:
                    sreftime = node0_start
                elif node[START_TIME_REF] == EXISTRING_NDOE and node[START_TIME_WHICH] == END:
                    sreftime = node0_end
                elif node[START_TIME_REF] == OFFSET_NODE and node[START_TIME_WHICH] == START:
                    sreftime = node1_start
                elif node[START_TIME_REF] == OFFSET_NODE and node[START_TIME_WHICH] == END:
                    sreftime = node1_end
                else:
                    #Error: there must be some ref specified.
                    sreftime = 0
                    print('ERROR')

                stime = sreftime + schange

                #Compute end time
                if node[END_TIME_REF] == EXISTRING_NDOE and node[END_TIME_WHICH] == START:
                    ereftime = node0_start
                elif node[END_TIME_REF] == EXISTRING_NDOE and node[END_TIME_WHICH] == END:
                    ereftime = node0_end
                elif node[END_TIME_REF] == OFFSET_NODE and node[END_TIME_WHICH] == START:
                    ereftime = node1_start
                elif node[END_TIME_REF] == OFFSET_NODE and node[END_TIME_WHICH] == END:
                    ereftime = node1_end
                else:
                    #Error: there must be some ref specified.
                    ereftime = 0
                    print('ERROR')

                etime = ereftime + echange

                #print(ereftime)
                #print(echange)
                #print(etime)

                #Compute duration.
                #node['durationCost'] = operation[OFFSET]
                node['durationCost'] = str(etime - stime)

                print(node['durationCost'])

    return 1



def find_match(graph, operation):
    #Reconcile the term used in the RO with node labels in the AG. These may be
    #equivalent terms as specified by an ontology but they may not be exactly
    #the same term/label. For now, we assume that an applicable RO always refers
    #to nodes such that an equivalent node exists in the AG.
    ro_existing_node = operation[EXISTRING_NDOE]
    print("RO node:")
    print(ro_existing_node)

    matched = False
    graphnodeslist = list(graph.nodes)

    for v in graphnodeslist:
        if v == ro_existing_node or match_terms(v, ro_existing_node):
            print("matched!")
            matched = True
            break

    if matched:
        existing_node = v
        return existing_node
    else:
        print("No match found")



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

    #Previously, we simply retrieved the node as specified in the RO, assuming that
    #the label of the equivalent node in the AG is the same. Now we use a matching
    #process to reconcile the term in the RO with the node label in the AG.
    #existing_node = operation[EXISTRING_NDOE]
    existing_node_id = find_match(graph, operation)
    print(existing_node_id)

    new_node_ids = [n["id"] for n in operation[NEW_NODES]]

    if operation[SEQUENCE] == THEN:
        # Add edges that connect nodes
        for i in range(len(new_node_ids) - 1):
            start_id = new_node_ids[i]
            end_id = new_node_ids[i + 1]
            graph.add_edge(start_id, end_id)
        start_node_ids, end_node_ids = [new_node_ids[0]], [new_node_ids[-1]]
    else:
        start_node_ids, end_node_ids  = new_node_ids, new_node_ids

    for pred_id in graph.predecessors(existing_node_id):
        edge_data = graph.get_edge_data(pred_id, existing_node_id)
        edge_data = edge_data[0] if edge_data else {}
        for node_id in start_node_ids:
            if not graph.has_edge(pred_id, node_id):
                graph.add_edge(pred_id, node_id,  **edge_data)

    for succ_id in graph.successors(existing_node_id):
        edge_data = graph.get_edge_data(existing_node_id, succ_id)
        edge_data = edge_data[0] if edge_data else {}
        for node_id in end_node_ids:
            if not graph.has_edge(node_id, succ_id):
                graph.add_edge(node_id, succ_id, **edge_data)


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

    #Find a match in the AG for the existing node to delete specified in the RO
    #node_to_delete = operation[EXISTRING_NDOE]
    node_to_delete = find_match(graph, operation)
    print(node_to_delete)


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

                #print(predecessor)
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
