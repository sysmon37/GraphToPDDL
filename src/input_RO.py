import json
import logging
from operator import itemgetter

from src.CONSTANTS import (
    ACTION_NODE,
    DECISION_NODE,
    DELETE_OPERATION,
    EDGE_TO_SUCCESSORS,
    EDGE_TO_SUCCESSORS_ATTR,
    EXISTING_NDOE,
    IS_ORIGINAL_ATTR,
    NEW_NODES,
    OPERATIONS,
    PREDECESSORS,
    RANGE_ATTR,
    REPLACE_OPERATION,
    SUCCESSORS,
    TRIGGER,
    TYPE_ATTR,
    TRIGGER_CONDITION,
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
        id, trigger, operations = itemgetter("id", TRIGGER, OPERATIONS)(ro)
        # This is to make the code work with old examples before introducing trigger condition
        trigger_condition = ro.get(TRIGGER_CONDITION, "")

        #If no triggering conditions are specified then continue with RO as is.
        #If a triggering condition is specified then check if the condition is met.
        #If the condition is met, proceed with RO. Otherwise do not apply the RO.

        for condition in trigger_condition:
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
                if node[START_TIME_REF] == EXISTING_NDOE and node[START_TIME_WHICH] == START:
                    sreftime = node0_start
                elif node[START_TIME_REF] == EXISTING_NDOE and node[START_TIME_WHICH] == END:
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
                if node[END_TIME_REF] == EXISTING_NDOE and node[END_TIME_WHICH] == START:
                    ereftime = node0_start
                elif node[END_TIME_REF] == EXISTING_NDOE and node[END_TIME_WHICH] == END:
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
    ro_existing_node = operation[EXISTING_NDOE]
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
    #Previously, we simply retrieved the node as specified in the RO, assuming that
    #the label of the equivalent node in the AG is the same. Now we use a matching
    #process to reconcile the term in the RO with the node label in the AG.
    #existing_node = operation[EXISTING_NDOE]

    base_node_id = find_match(graph, operation)
    logging.debug(f"base = {base_node_id}")
    
    # Add a sequence of nodes defined in a revision operator
    new_node_ids = []
    for n in operation[NEW_NODES]:
        # taking node id and the rest of its attributes
        new_node = {**n}
        new_node_id = new_node["id"]
        new_node_type = new_node[TYPE_ATTR]

        if new_node_type == ACTION_NODE:
            new_node[IS_ORIGINAL_ATTR] = False

        new_node.pop("id", None)
        new_node.pop(TYPE_ATTR, None)
        new_node.pop(PREDECESSORS, None)
        new_node.pop(SUCCESSORS, None)
        new_node.pop(EDGE_TO_SUCCESSORS, None)

        graph.add_node(new_node_id, type=new_node_type, idRO=id_ro, trigger=trigger, **new_node)
        logging.debug(f"adding node = {new_node_id} | {new_node_type} | {new_node}")
        if new_node_ids != []:
            graph.add_edge(new_node_ids[-1], new_node_id)
            logging.debug(f"adding edge = {new_node_ids[-1]} -> {new_node_id}")

        new_node_ids.append(new_node_id)

    # Connect base predecessors to the first new node
    for pred_node_id in graph.predecessors(base_node_id):
        edge_data = graph.get_edge_data(pred_node_id, base_node_id)
        edge_data = edge_data[0] if edge_data else {}
        if not graph.has_edge(pred_node_id, new_node_ids[0]):
            graph.add_edge(pred_node_id, new_node_ids[0], **edge_data)
            logging.debug(f"adding edge = {pred_node_id} -> {new_node_ids[0]} | {edge_data}")

    # Connect the last new node to base successors
    for succ_node_id in list(graph.successors(base_node_id)):
        edge_data = graph.get_edge_data(base_node_id, succ_node_id)
        edge_data = edge_data[0] if edge_data else {}
        if not graph.has_edge(new_node_ids[-1], succ_node_id):
            graph.add_edge(new_node_ids[-1], succ_node_id, **edge_data)
            logging.debug(f"adding edge = {new_node_ids[-1]} -> {succ_node_id} | {edge_data}")


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
