import json
from graphviz import Digraph
from networkx import DiGraph
from Constants import DISEASE_NODE, GOAL_NODE, DECISION_NODE, ACTION_NODE, REVISION_NODE, FORMAT_OPTIONS

class ActionGraph:
    '''
    This class represents an action graph, which is a directed graph of clinical actions.
    '''
    def __init__(self):
        self.graph = DiGraph()
        self.actions = {}
    
    def add_fhir_actions(self, fhir_path: str):
        '''
        Add fhir PlanDefinition actions from a json file to the graph.

        :param fhir_path: path to the json file containing the PlanDefinition.
        '''
        fhir_file = open(fhir_path, encoding="utf-8")
        self.actions = {**self.actions, **{action["id"]: action for action in json.load(fhir_file)["action"]}}
        fhir_file.close()
    
    def add_action(self, action: dict):
        '''
        Add PlanDefinition action to the graph.

        :param action: PlanDefinition action, compliant to FHIR standard.
        '''
        self.actions[action["id"]] = action

    def add_relation(self, action_id: str, relation_data: dict):
        '''
        Add relation to the action.

        :param action_id: id of the action.
        :param relation_data: dictionary containing the relation data.
        '''
        if action_id not in self.actions:
            return
        if "relatedAction" not in self.actions[action_id]:
            self.actions[action_id]["relatedAction"] = []
        self.actions[action_id]["relatedAction"].append(relation_data)

    def get_node_type(self, node_id: str) -> str:
        '''
        Get the type of the node based on its relationships.
        
        :param node: id of the action.
        :return: type of the node (start, decision, etc).
        '''
        if self.graph.in_degree(node_id) == 0:
            return DISEASE_NODE
        if self.graph.out_degree(node_id) == 0:
            return GOAL_NODE
        for successor in self.graph.successors(node_id):
            if "condition" in self.actions[successor]:
                for condition in self.actions[successor]["condition"]:
                    # Check if any of the condition targets points to the current node
                    # Expressions in MitPlan language are in the form of "target value_range"
                    if "expression" in condition and condition["expression"]["expression"].split(" ")[0] == node_id:
                        return DECISION_NODE
        if "revision_id" in self.graph.nodes[node_id]:
            return REVISION_NODE
        return ACTION_NODE

    def nwx2graphviz(self) -> Digraph:
        '''
        Convert networkx graph into graphviz graph.

        :return: graphviz Digraph.
        '''
        dot_graph = Digraph()
        for node in self.graph.nodes:
            dot_graph.node(
                name=node,
                label=self.graph.nodes[node]["title"] if "title" in self.graph.nodes[node] else node,
                style="filled",
                **FORMAT_OPTIONS[self.graph.nodes[node]["type"]]
            )
        
        for edge in self.graph.edges:
            if 'targetId' in self.graph.edges[edge] and self.graph.nodes[edge[0]]["type"] == DECISION_NODE:
                dot_graph.edge(
                    edge[0], edge[1],
                    f"{self.graph.edges[edge]['targetId']} {self.graph.edges[edge]['range']}"
                )
            else:
                dot_graph.edge(edge[0], edge[1], "")
        return dot_graph
    
    def render_graphviz(self, dot_graph: Digraph, filename: str = "out", output_dir: str = "."):
        '''
        Save graphviz graph into a png file.

        :param dot_graph: the graphviz Digraph to save.
        :param filename: name of the output file.
        :param output_dir: directory of the file.
        '''
        dot_graph.render(
            directory="{}{}".format(output_dir, "/" if output_dir else ""),
            filename=filename,
            format="png",
            cleanup=True
        )
    
    def update_relations(self):
        '''
        Update the types of actions in the graph and relationships between decision nodes and actions.
        '''
        for node in self.graph.nodes:
            self.graph.nodes[node]["type"] = self.get_node_type(node)
            if self.graph.nodes[node]["type"] == DECISION_NODE:
                for child in self.graph.successors(node):
                    if "condition" in self.actions[child]:
                        for condition in self.actions[child]["condition"]:
                            target, value_range = condition["expression"]["expression"].split(" ")
                            if target == node:
                                self.graph.edges[(node, child)]["range"] = value_range
                                self.graph.edges[(node, child)]["targetId"] = target
                                break

    def update_graph(self):
        '''
        Recreate the graph using the actions added to the ActionGraph so far.
        '''
        self.graph = DiGraph()
        for action_id in self.actions:
            self.graph.add_node(action_id)
            # Update the node details with entire action json from source
            self.graph.nodes[action_id].update(self.actions[action_id])
            if "relatedAction" in self.actions[action_id] and len(self.actions[action_id]["relatedAction"]) > 0:
                for related_action in self.actions[action_id]["relatedAction"]:
                    # After means that the target should be placed after the current action
                    if related_action["relationship"] == "after":
                        self.graph.add_edge(action_id, related_action["targetId"])
                    # Before means that the target should be placed before the current action
                    elif related_action["relationship"] == "before":
                        self.graph.add_edge(related_action["targetId"], action_id)
        self.update_relations()

