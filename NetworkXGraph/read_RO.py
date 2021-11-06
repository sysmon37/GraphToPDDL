import json
from operator import itemgetter
import networkx as nwx
from networkx.classes.digraph import DiGraph
import DotGraphCreator as dgc


def read_RO(path):
    with open(path) as file:
        ros = json.load(file)
        file.close()
    return ros


def update_graph_with_ROs(graph, ros):
    for ro in ros:
        id, trigger, operations = itemgetter("id", "trigger", "operations")(ro)
        operations = ro["operations"]
        for op in operations:
            type = op["type"]
            if type == "replace":
                replace_action(graph, id, trigger, op)
            elif type == "delete":
                # not sure what to do here
                print("deleting")
            else:
                print("Adding")
                add_action(graph, id, trigger, op)

# Creating sibling nodes
def replace_action(graph: DiGraph, idRO, trigger, operation):
    existing_node = operation["existingNode"]
    parent_nodes = list(graph.predecessors(existing_node))

    # Loop over all the parents of the existing node
    for parent_node in parent_nodes:
        is_first_new_node = True
 
        for node in operation["newNodes"]:
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

            # copying the edge data if any but only to the first new node
            edge_range = graph.get_edge_data(parent_node, existing_node)
            edge_range = edge_range[0] if edge_range else {}
            graph.add_edge(
                parent_node, new_node_id, **edge_range if is_first_new_node else {}
            )

            # wont copy edge attributes further
            is_first_new_node = False

            # updating the parent node so the next new node has the correct edge
            parent_node = new_node_id

    # need one last edge from the last added node to the same node 'Existing_node' is pointing too
    graph.add_edge(parent_node, list(graph.successors(existing_node))[0])



# Insert(ADD) a nodes in the graph from a predeccessors and a successors list
def add_action(graph: DiGraph, idRO, trigger, operation):

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
                if graph.get_edge_data(predecessor, successor):
                    # Adding the edge between the new node and the predecessor with the edge data
                    # We only want one edge between the predecessor and the new node
                    if not graph.get_edge_data(predecessor, new_node_id):
                        graph.add_edge(predecessor, new_node_id, **graph.get_edge_data(predecessor, successor)[0])

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
                            if not graph.get_edge_data(predecessor, new_node_id):
                                graph.add_edge(predecessor, new_node_id, **tmpData)
                            break
                print(graph.edges(new_node_id))
            # Adding the edge between the new node and the successor with the edge data

            # We only want one edge between the new node and the successor
            if not graph.get_edge_data(new_node_id, successor):
                graph.add_edge(new_node_id, successor)
           

                            

                        
                    
                




