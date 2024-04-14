import json
from ActionGraph import ActionGraph

class RevisionOperators:
    '''
    This class is responsible for storing and applying revision operators.
    '''
    def __init__(self):
        self.revision_declarations = {}
        self.revision_definitions = {}
        # Revision declarations and definitions grouped together
        self.revision_operators = {}
    
    def add_fhir_revision_operators(self, fhir_path: str):
        '''
        Add revision operators from fhir file.

        :param fhir_path: path to the json file containing the revision operators.
        '''
        fhir_file = open(fhir_path, encoding="utf-8")
        json_data = json.load(fhir_file)
        self.revision_declarations = {**self.revision_declarations, **{revision["id"]: revision for revision in json_data["revision_declarations"]}}
        self.revision_definitions = {**self.revision_definitions, **{revision["id"]: revision for revision in json_data["revision_definitions"]}}
        fhir_file.close()
    
    def update_revision_operators(self):
        '''
        Merge revision declarations and definitions into revision operators.
        '''
        for revision in self.revision_declarations:
            self.revision_operators[revision] = self.revision_declarations[revision]
            merged_revision_mitigation = []
            for mitigation_action in self.revision_operators[revision]["mitigation"]:
                merged_revision_mitigation.append({
                    **mitigation_action,
                    "definition": self.revision_definitions[mitigation_action["action"]["coding"][0]["code"]]
                })
            self.revision_operators[revision]["mitigation"] = merged_revision_mitigation
    
    def get_revision_triggers(self) -> dict:
        '''
        Get revision triggers grouped by revision id.

        :return: dictionary of revision triggers.
        '''
        triggers = {}
        for revision in self.revision_declarations:
            triggers[revision] = [trigger["reference"] for trigger in self.revision_declarations[revision]["implicated"]]
        return triggers
    
    def get_revision_ids(self) -> list:
        '''
        Get a list of revision declaration ids.

        :return: list of revision ids.
        '''
        return [revision_id for revision_id in self.revision_declarations]

    def generate_dummy_node(self, ag, revision_id) -> dict:
        '''
        Generate a dummy node for add revision operators for the graph.

        :param ag: Action Graph to connect the dummy node for.
        :param revision_id: revision id of the dummy node.
        :return: dummy node dictionary.
        '''
        dummy_idx = 0
        while f"dummy_{dummy_idx}" in ag.graph.nodes:
            dummy_idx += 1
        dummy_node = {
            "id": f"DUMMY{dummy_idx}",
            "is_dummy": True,
            "revision_id": revision_id,
        }
        return dummy_node
    
    def apply_replace(self, ag, mitigation, revision_id):
        '''
        Apply mitigation by replacing a node in the graph.

        :param ag: Action Graph to apply mitigation to.
        :param mitigation: mitigation to apply.
        :param revision_id: revision id of the mitigation.
        '''
        target_node = mitigation["note"]
        target_predecessors = list(ag.graph.predecessors(target_node))
        target_successors = list(ag.graph.successors(target_node))
        subgraph = ActionGraph()
        # Create a sub-ActionGraph in order to sort the actions
        for new_node in mitigation["definition"]["action"]:
            subgraph.add_action(new_node)
        subgraph.update_graph()
        # Apply sub-ActionGraph actions to the main graph
        for node in subgraph.graph.nodes:
            new_action = {**subgraph.graph.nodes[node]}
            new_action["revision_id"] = revision_id
            if "relatedAction" not in new_action:
                new_action["relatedAction"] = []
            # Add connections between replaced node's successors and predecessors
            # to the first node and final node of the sub-ActionGraph
            if subgraph.graph.in_degree(node) == 0:
                new_action["relatedAction"] += [
                    { "targetId": predecessor, "relationship": "before" }
                    for predecessor in target_predecessors
                ]
            if subgraph.graph.out_degree(node) == 0:
                new_action["relatedAction"] += [
                    { "targetId": successor, "relationship": "after" }
                    for successor in target_successors
                ]
            ag.add_action(new_action)
        # Update connections and relations in the original graph
        ag.update_graph()

    def apply_delete(self, ag, mitigation):
        '''
        Apply mitigation by deleting a node in the graph.
        
        :param ag: Action Graph to apply mitigation to.
        :param mitigation: mitigation to apply.
        '''
        target_node = mitigation["note"]
        target_predecessors = list(ag.graph.predecessors(target_node))
        target_successors = list(ag.graph.successors(target_node))
        # Deletion simply means adding additional edges between the predecessors and successors
        # of the target node
        for successor in target_successors:
            for predecessor in target_predecessors:
                ag.add_relation(predecessor, { "targetId": successor, "relationship": "after" })
    
    def apply_add(self, ag, mitigation, revision_id):
        '''
        Apply mitigation by adding a node to the graph.

        :param ag: Action Graph to apply mitigation to.
        :param mitigation: mitigation to apply.
        :param revision_id: revision id of the mitigation.
        '''
        for action in mitigation["definition"]["action"]:
            new_action = {**action}
            new_action["revision_id"] = revision_id
            ag.add_action(new_action)

            dummy_node = self.generate_dummy_node(ag, revision_id)
            if "relatedAction" in new_action:
                dummy_node["relatedAction"] = new_action["relatedAction"]
            if "condition" in new_action:
                dummy_node["condition"] = new_action["condition"]
            ag.add_action(dummy_node)

    def apply_to_graph(self, ag):
        '''
        Apply revision operators to an Action Graph.

        :param ag: Action Graph to apply revision operators to.
        '''
        for rev_id in self.revision_operators:
            triggers = [trigger["reference"] for trigger in self.revision_operators[rev_id]["implicated"]]
            # Only apply revision operator if all triggers are present in the graph
            if all(trigger in ag.graph.nodes for trigger in triggers):
                for mitigation in self.revision_operators[rev_id]["mitigation"]:
                    # Note is the target of the mitigation
                    # if there is a target and actions to replace it with -> replace
                    # if there is a target but no actions to replace it with -> delete
                    # if there is no target -> add
                    if "note" in mitigation:
                        if len(mitigation["definition"]["action"]) > 0:
                            self.apply_replace(ag, mitigation, rev_id)
                        else:
                            self.apply_delete(ag, mitigation)
                    else:
                        self.apply_add(ag, mitigation, rev_id)
