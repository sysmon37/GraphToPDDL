import json

from networkx import DiGraph
from Constants import DISEASE_NODE, GOAL_NODE, DECISION_NODE, ACTION_NODE, REVISION_NODE, DUMMY_NODE
from RevisionOperators import RevisionOperators

class GraphToPDDL:
    '''
    This class is responsible for converting DiGraphs into PDDL files.

    :param problem_name: name of the pddl problem file.
    :param domain_name: name of the pddl domain.
    :param graph: DiGraph to be converted.
    :param revision_operators: RevisionOperators object containing revision operators.
    '''
    def __init__(self, problem_name: str, domain_name: str, graph: DiGraph, revision_operators: RevisionOperators):
        self.problem_name = problem_name
        self.domain_name = domain_name
        self.graph = graph
        self.grouped_nodes = self.group_nodes_by_type()
        self.revision_operators = revision_operators
    
    def group_nodes_by_type(self):
        '''
        Split nodes into groups based on their type.

        :return: dictionary with node type as key and list of nodes as value.
        '''
        start_nodes = [node for node in self.graph.nodes if self.graph.nodes[node]["type"] == DISEASE_NODE]
        decision_nodes = [node for node in self.graph.nodes if self.graph.nodes[node]["type"] == DECISION_NODE]
        action_nodes = [node for node in self.graph.nodes if self.graph.nodes[node]["type"] == ACTION_NODE]
        goal_nodes = [node for node in self.graph.nodes if self.graph.nodes[node]["type"] == GOAL_NODE]
        revision_nodes = [node for node in self.graph.nodes if self.graph.nodes[node]["type"] == REVISION_NODE]
        dummy_nodes = [node for node in self.graph.nodes if self.graph.nodes[node]["type"] == DUMMY_NODE]
        return {
            DISEASE_NODE: start_nodes,
            DECISION_NODE: decision_nodes,
            ACTION_NODE: action_nodes,
            GOAL_NODE: goal_nodes,
            REVISION_NODE: revision_nodes,
            DUMMY_NODE: dummy_nodes
        }
    
    def write_header(self, pddl_file):
        '''
        Write the PDDL header into PDDL file.

        :param pddl_file: file to write the header to.
        '''
        pddl_file.write(f"(define (problem {self.problem_name})\n\t(:domain {self.domain_name})\n")
    
    def write_objects(self, pddl_file):
        '''
        Write PDDL objects into pddl file.

        :param pddl_file: file to write the objects to.
        '''
        pddl_file.write(f"(:objects {' '.join(self.grouped_nodes[DISEASE_NODE])} - disease\n")
        pddl_file.write(
            f"\t{' '.join(self.grouped_nodes[DECISION_NODE])} "
            f"{' '.join(self.grouped_nodes[ACTION_NODE])} "
            f"{' '.join(self.grouped_nodes[GOAL_NODE])} "
            f"{' '.join(self.grouped_nodes[DUMMY_NODE])} "
            f"{' '.join(self.grouped_nodes[REVISION_NODE])} - node\n"
        )
        pddl_file.write(f"\t{' '.join(self.revision_operators.get_revision_ids())} - revId\n")
        pddl_file.write(f"\t{' '.join([ 'DATA_' + node for node in self.grouped_nodes[DECISION_NODE]])} - DataItem\n")
        pddl_file.write(")\n")

    def write_variables(self, pddl_file, revision_by_disease: dict):
        '''
        Write MitPlan variables into PDDL file.

        :param pddl_file: file to write the variables to.
        :param revision_by_disease: dict with revisions grouped by diseases.
        '''
        for node in self.grouped_nodes[DISEASE_NODE]:
            pddl_file.write(f"\t(= (allRevisionsPass {node}) 0)\n")
        for disease in revision_by_disease:
            pddl_file.write(f"\t(= (numRevisionIDs {disease}) {len(revision_by_disease[disease])})\n")
        pddl_file.write("\n")
        for node in self.grouped_nodes[DISEASE_NODE]:
            pddl_file.write(f"\t(anyRevisionOps {node})\n")
        pddl_file.write("\n")
        pddl_file.write(f"\t(= (tentativeGoalCount) 0)\n")
        pddl_file.write("\n")
        pddl_file.write(f"\t(= (numGoals) {len(self.grouped_nodes[GOAL_NODE])})\n")
        pddl_file.write("\n")
        # Variables used to calculate optimalization metric
        pddl_file.write(f"\t(= (total-execcost) 0)\n")
        pddl_file.write(f"\t(= (total-cost) 0)\n")
        pddl_file.write(f"\t(= (total-burden) 0)\n")
        pddl_file.write(f"\t(= (total-nonadherence) 0)\n")
        pddl_file.write(f"\t(= (total-duration) 0)\n")
        pddl_file.write("\n")
    
    def write_revision_operators(self, pddl_file, triggers: dict):
        '''
        Write MitPlan revision operators into PDDL file.

        :param pddl_file: file to write the revision operators to.
        :param triggers: dictionary with keys set to revision ids and values to trigger nodes' ids.
        '''
        for revision_id in triggers:
            total_triggers = 0
            for node in self.graph.nodes:
                if node not in self.grouped_nodes[DISEASE_NODE] and node not in self.grouped_nodes[DUMMY_NODE]:
                    num_triggers = len([trigger for trigger in triggers[revision_id] if trigger == node])
                    total_triggers += num_triggers
                    # The amount of revision triggers for this node
                    pddl_file.write(f"\t(= (revisionFlag {node} {revision_id}) {num_triggers})\n")
                if node in self.grouped_nodes[DUMMY_NODE] and self.graph.nodes[node]["revision_id"] == revision_id:
                    total_triggers += 1
                    pddl_file.write(f"\t(= (revisionFlag {node} {revision_id}) 1)\n")
            pddl_file.write("\n")
            # Total amount of triggers for this revision id
            pddl_file.write(f"\t(= (revisionSequenceNumNodes {revision_id}) {total_triggers})\n")
            # The amount of nodes that this revision targets
            # Due to FHIR standard limitations, revision operator can target at most 1 node
            pddl_file.write(f"\t(= (numNodesToReplace {revision_id}) 1)\n")
            # Variables managed by the planner, always set to 0
            pddl_file.write(f"\t(= (revisionCount {revision_id}) 0)\n")
            for node in self.grouped_nodes[DISEASE_NODE]:
                pddl_file.write(f"\t(= (revisionIDPass {node} {revision_id}) 0)\n")
            pddl_file.write("\n")
        pddl_file.write("\n")

    def write_decision_branches(self, pddl_file, decision_branches: list):
        '''
        Write decision branches into PDDL file.

        :param pddl_file: file to write the decision branches to.
        :param decision_branches: list of decision branches in triples (disease, parent, child).
        '''
        for decision_branch in decision_branches:
            if "condition" in self.graph.nodes[decision_branch[2]]:
                for condition in self.graph.nodes[decision_branch[2]]["condition"]:
                    target, values = condition["expression"]["expression"].split(" ")
                    min_value, max_value = values.split("..")
                    if target == decision_branch[1]:
                        pddl_file.write(
                            f"\t(= "
                            f"(decisionBranchMin {decision_branch[0]} {decision_branch[1]} {decision_branch[2]}) "
                            f"{min_value})\n"
                        )
                        pddl_file.write(
                            f"\t(= "
                            f"(decisionBranchMax {decision_branch[0]} {decision_branch[1]} {decision_branch[2]}) "
                            f"{max_value})\n"
                        )
        pddl_file.write("\n")
            
    def write_data_items(self, pddl_file):
        '''
        Write data items into PDDL file.

        :param pddl_file: file to write the data items to.
        '''
        for node in self.grouped_nodes[DECISION_NODE]:
            pddl_file.write(f"\t(dataItem {node} DATA_{node})\n")
        pddl_file.write("\n")
    
    def write_initial_goal_nodes(self, pddl_file, initial_nodes: list, goal_nodes: list):
        '''
        Write initial nodes and goals into the PDDL file.

        :param pddl_file: file to write the initial nodes and goals to.
        :param initial_nodes: list of first nodes after the disease node (disease, next node).
        :param goal_nodes: list of goal nodes (disease, final node).
        '''
        for node in initial_nodes:
            pddl_file.write(f"\t(initialNode {node[0]} {node[1]})\n")
        for node in goal_nodes:
            pddl_file.write(f"\t(goalNode {node[0]} {node[1]})\n")
        pddl_file.write("\n")
    
    def write_predecessor_nodes(self, pddl_file):
        '''
        Write the information about node predecessors into the PDDL file.

        :param pddl_file: file to write the predecessor nodes to.
        '''
        for edge in self.graph.edges:
            # Skip starting nodes
            if edge[0] in self.grouped_nodes[DISEASE_NODE]:
                continue
            pddl_file.write(f"\t(predecessorNode {edge[0]} {edge[1]})\n")
        pddl_file.write("\n")

    def write_nodes(self, pddl_file):
        '''
        Write all nodes except of disease nodes into the PDDL file.

        :param pddl_file: file to write the nodes to.
        '''
        for node in self.grouped_nodes[ACTION_NODE]:
            pddl_file.write(f"\t(actionNode {node})\n")
        for node in self.grouped_nodes[DECISION_NODE]:
            pddl_file.write(f"\t(decisionNode {node})\n")
        for node in self.grouped_nodes[REVISION_NODE]:
            pddl_file.write(f"\t(actionNode {node})\n")
        for node in self.grouped_nodes[DUMMY_NODE]:
            pddl_file.write(f"\t(dummyNode {node})\n")
        pddl_file.write("\n")

    def write_actions(self, pddl_file):
        '''
        Write both original actions and revision operator actions into the PDDL file.

        :param pddl_file: file to write the actions to.
        '''
        for node in self.grouped_nodes[ACTION_NODE]:
            pddl_file.write(f"\t(originalAction {node})\n")
        pddl_file.write("\n")
        for node in self.grouped_nodes[REVISION_NODE]:
            pddl_file.write(f"\t(revisionAction {node} {self.graph.nodes[node]['revision_id']})\n")
        pddl_file.write("\n")

    def write_dynamic_values(self, pddl_file):
        '''
        Write dynamic values for every node in the graph into the PDDL file.

        :param pddl_file: file to write the dynamic values to.
        '''
        for node in self.graph.nodes:
            # Skip disease nodes
            if node in self.grouped_nodes[DISEASE_NODE] or node in self.grouped_nodes[DUMMY_NODE]:
                continue

            node_exec_cost = 0
            node_cost = 0
            node_burden = 0
            node_nonadherence = 0
            node_start_time = 0
            node_end_time = 0
            node_duration = 0

            if "dynamicValue" in self.graph.nodes[node]:
                for dynamic_value in self.graph.nodes[node]["dynamicValue"]:
                    # Skip non-MitPlan specific dynamic values
                    if dynamic_value["expression"]["language"] != "text/mitplan":
                        continue
                    variable, value = dynamic_value["expression"]["expression"].split("=")
                    if variable == "execCost":
                        node_exec_cost = value
                    elif variable == "cost":
                        node_cost = value
                    elif variable == "burden":
                        node_burden = value
                    elif variable == "nonadherence":
                        node_nonadherence = value
                    elif variable == "startTime":
                        node_start_time = value
                    elif variable == "endTime":
                        node_end_time = value
                    elif variable == "duration":
                        node_duration = value
            
            pddl_file.write(f"\t(= (nodeExecCost {node}) {node_exec_cost})\n")
            pddl_file.write(f"\t(= (nodeCost {node}) {node_cost})\n")
            pddl_file.write(f"\t(= (nodeBurden {node}) {node_burden})\n")
            pddl_file.write(f"\t(= (nodeNonadherence {node}) {node_nonadherence})\n")
            pddl_file.write(f"\t(= (nodeStartTime {node}) {node_start_time})\n")
            pddl_file.write(f"\t(= (nodeEndTime {node}) {node_end_time})\n")
            pddl_file.write(f"\t(= (nodeDuration {node}) {node_duration})\n")
            pddl_file.write("\n")

    def write_final_goal(self, pddl_file, start_goal_nodes: list):
        '''
        Write final goal (treatmentPlanReady) into the PDDL file.

        :param pddl_file: file to write the final goal to.
        :param start_goal_nodes: list of tuples (disease, goal node).
        '''
        pddl_file.write(f"(:goal (and")
        for nodes in start_goal_nodes:
            pddl_file.write(f"\t(treatmentPlanReady {nodes[0]} {nodes[1]})\n")
        pddl_file.write("\t)\n)\n")
    
    def write_metric(self, pddl_file):
        '''
        Write the metric optimized by the planner into the PDDL file.

        :param pddl_file: file to write the metric to.
        '''
        pddl_file.write(
            "(:metric minimize\n"
            "\t(+ (total-execcost)\n"
            "(total-cost)\n"
            "(total-burden)\n"
            "(total-nonadherence)\n"
            "(total-duration)\n"
            "))\n"
            ")"
        )
    
    def write_patient_data(self, pddl_file, patient_file: str):
        '''
        Write patient data into the PDDL file.

        :param pddl_file: file to write the patient data to.
        :param patient_file: path to the patient data file (in json).
        '''
        file_handle = open(patient_file, "r", encoding="utf-8")
        patient_observations = json.load(file_handle)
        for observation in patient_observations:
            key = observation["component"][0]["code"]["coding"][0]["code"]
            pddl_file.write(f"\t(= (dataValue DATA_{key}) {observation['valueQuantity']['value']})\n")
        file_handle.close()
        pddl_file.write("\n")
    
    def get_start_node(self, source_node: str) -> list:
        '''
        Get the disease node of the given node.

        :param source_node: node to get the disease node from.

        :return: disease node.
        '''
        current_node = source_node
        while len(list(self.graph.predecessors(current_node))) > 0:
            current_node = list(self.graph.predecessors(current_node))[0]
        return current_node

    def get_decision_branches(self) -> list:
        '''
        Get decision branches to save to PDDL file for the current graph.

        :return: list of decision branches in triples (disease, parent, child).
        '''
        decision_branches = []
        for node in self.grouped_nodes[DECISION_NODE]:
            start_node = self.get_start_node(node)
            for successor in self.graph.successors(node):
                decision_branches.append((start_node, node, successor))
        return decision_branches

    def get_final_node(self, start_node: str) -> str:
        '''
        Get the goal node of the given node.

        :param start_node: node to get the goal node from.
        :return: goal node.
        '''
        successors = list(self.graph.successors(start_node))
        current_node = start_node
        while len(successors) > 0:
            current_node = successors[0]
            successors = list(self.graph.successors(current_node))
        return current_node

    def get_revisions_by_disease(self, revision_triggers: list) -> dict:
        '''
        Get dict with revisions grouped by diseases.

        :param revision_triggers: revision triggers grouped by revision id.
        :return: dict with diseases as keys and list of revisions as values.
        '''
        revision_diseases = {}
        for node in self.grouped_nodes[DISEASE_NODE]:
            revision_diseases[node] = []
        for trigger in revision_triggers:
            for node in revision_triggers[trigger]:
                start_node = self.get_start_node(node)
                if node not in revision_diseases[start_node]:
                    revision_diseases[start_node].append(node)
        return revision_diseases

    def write_pddl(self, output_path: str, patient_file: str):
        '''
        Write current graph into the PDDL file.

        :param output_path: path to the output PDDL file.
        :param patient_file: path to the patient data file (in json).
        '''
        pddl_file = open(output_path, "w", encoding="utf-8")
        self.write_header(pddl_file)
        self.write_objects(pddl_file)
        pddl_file.write("(:init\n")
        self.write_decision_branches(pddl_file, self.get_decision_branches())
        self.write_data_items(pddl_file)
        self.write_patient_data(pddl_file, patient_file)
        self.write_initial_goal_nodes(
            pddl_file,
            [(node, list(self.graph.successors(node))[0]) for node in self.grouped_nodes[DISEASE_NODE]],
            [(node, self.get_final_node(node)) for node in self.grouped_nodes[DISEASE_NODE]]
        )
        self.write_predecessor_nodes(pddl_file)
        self.write_nodes(pddl_file)
        self.write_actions(pddl_file)
        self.write_revision_operators(pddl_file, self.revision_operators.get_revision_triggers())
        self.write_variables(
            pddl_file,
            self.get_revisions_by_disease(self.revision_operators.get_revision_triggers())
        )
        self.write_dynamic_values(pddl_file)
        pddl_file.write(")\n\n")
        self.write_final_goal(pddl_file, [(node, self.get_final_node(node)) for node in self.grouped_nodes[DISEASE_NODE]])
        pddl_file.write("\n")
        self.write_metric(pddl_file)
        pddl_file.close()
