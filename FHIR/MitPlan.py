import json
import subprocess
from ActionGraph import ActionGraph
from GraphToPDDL import GraphToPDDL
from RevisionOperators import RevisionOperators

class MitPlan:
    '''
    This class ties everything together into MitPlan.

    :param plan_files: list of paths to the json files containing PlanDefinitions.
    :param revision_files: list of paths to the json files containing revision operators.
    :param patient_datafile: path to the json file containing patient data.
    :param problem_name: name of the PDDL problem.
    :param domain_name: name of the PDDL domain.
    '''
    def __init__(
        self,
        plan_files: list = [],
        revision_files: list = [],
        patient_datafile: str = "data.json",
        problem_name: str = "mitplan-problem",
        domain_name: str = "mitplan-domain"
    ):
        self.graph = ActionGraph()
        self.ro = RevisionOperators()
        self.problem_name = problem_name
        self.domain_name = domain_name
        self.patient_datafile = patient_datafile
        self.plan_files = plan_files
        self.revision_files = revision_files
        # The result of rewrite-no-lp optimizer
        self.optimizer_result = None
        # Query created based on patient data to send to LLM
        self.patient_data_query = ""
        # Queries of actions selected by the optimizer to send to LLM
        self.queries = []
    
    def add_plan_file(self, plan_file: str):
        '''
        Add a PlanDefinition file to the list of PlanDefinitions.

        :param plan_file: path to the json file containing PlanDefinition.
        '''
        self.plan_files.append(plan_file)
    
    def add_revision_file(self, revision_file: str):
        '''
        Add a revision operator file to the list of revision operators.

        :param revision_file: path to the json file containing revision operators.
        '''
        self.revision_files.append(revision_file)
    
    def create_graph(self):
        '''
        Create action graph based on added PlanDefinitions and apply revision operators.
        '''
        for plan_file in self.plan_files:
            self.graph.add_fhir_actions(plan_file)
        self.graph.update_graph()
        for revision_file in self.revision_files:
            self.ro.add_fhir_revision_operators(revision_file)
        self.ro.update_revision_operators()
        self.ro.apply_to_graph(self.graph)
    
    def generate_pddl(self):
        '''
        Generate pddl problem file from actions in the action graph.
        '''
        g2pddl = GraphToPDDL(self.problem_name, self.domain_name, self.graph.graph, self.ro)
        g2pddl.write_pddl(f"{self.problem_name}.pddl", self.patient_datafile)
    
    def render_graph(self, filename = "graph", output_dir = "."):
        '''
        Render the action graph into png file using graphviz.

        :param filename: name of the output file.
        :param output_dir: directory of the file.
        '''
        self.graph.render_graphviz(self.graph.nwx2graphviz(), filename, output_dir)

    def parse_optimizer_result(self, paths: list) -> dict:
        '''
        Extract action ids from optimizer result.

        :param paths: list of paths from the optimizer result.
        :return: dictionary of disease and list of action ids selected by the optimizer.
        '''
        parsed_paths = {}
        for path in paths:
            path_chunks = path.split(" ")
            disease = path_chunks[2].upper()
            # (activate-initial-node disease first_node_after_start_node)
            if "activate-initial-node" in path:
                parsed_paths[disease] = [path_chunks[3][:-1].upper()]
            # (make-decision disease decision_node next_node data_{decision_node})
            elif "make-decision" in path:
                decision_node = path_chunks[3].upper()
                next_node = path_chunks[4].upper()
                if decision_node not in parsed_paths[disease]:
                    parsed_paths[disease].append(decision_node)
                parsed_paths[disease].append(next_node)
            # (take-original-action disease prev_node next_node)
            elif "take-original-action" in path:
                prev_node = path_chunks[3].upper()
                next_node = path_chunks[4][:-1].upper()
                if prev_node not in parsed_paths[disease]:
                    parsed_paths[disease].append(prev_node)
                parsed_paths[disease].append(next_node)
            # (final-goal-reached disease goal_node)
            elif "final-goal-reached" in path:
                goal_node = path_chunks[3][:-1].upper()
                if goal_node not in parsed_paths[disease]:
                    parsed_paths[disease].append(goal_node)
        return parsed_paths
    
    def run_optimizer(self):
        '''
        Run rewrite-no-lp on the generated pddl files and parse the result.
        '''
        command = f"./rewrite-no-lp --optimise {self.domain_name}.pddl {self.problem_name}.pddl"
        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        output, error = process.communicate()
        decoded_output = output.decode()
        save = False
        result = []
        for line in decoded_output.split('\n'):
            # Start saving output of the opitmizer only when optimal solution is found
            if "Solution Found and Proved Optimal" in line:
                save = True
            if save and any(
                [word in line for word in [
                    "activate-initial-node", "make-decision",
                    "take-original-action", "take-revised-action",
                    "final-goal-reached"
                    ]
                ]):
                result.append(line)
        self.optimizer_result = self.parse_optimizer_result(result)
    
    def generate_plan_query(self, disease: str):
        '''
        Generate LLM query for a specific disease based on optimizer output.

        :param disease: name of the disease.
        :return: LLM query for that disease.
        '''
        query = f"Clinical practice guidelines for treating the pateint with {disease}:\n"
        for action in self.optimizer_result[disease]:
            query += f"{self.graph.get_action(action)['title']}\n"
        return query

    def generate_queries(self, skip_decisions: bool = True, include_other_plans: bool = False):
        '''
        Generate queries for LLM model.

        :param skip_decisions: whether to skip decision nodes in the query.
        :param include_other_plans: whether to include other plans in the query.
        :return: list of queries.
        '''
        self.run_optimizer()
        diseases = [disease for disease in self.optimizer_result]
        queries = []
        for disease in self.optimizer_result:
            cur_idx = 0
            disease_names = ', '.join([self.graph.get_action(disease)['title'] for disease in diseases])
            query = ""
            # If other plans are included, generate queries for other diseases
            if include_other_plans:
                query += f"In order to treat the patient with {disease_names}, the doctor decided to follow these clinical practice guidelines:\n"
                other_diseases = [other_disease for other_disease in diseases if other_disease != disease]
                for other_disease in other_diseases:
                    query += self.generate_plan_query(other_disease)
                query += f"Then these plans had to executed simultaneously with the folowing plan for treating {disease}:\n"
            if skip_decisions:
                query += f'In order to treat the patient with {disease_names}, the doctor did the following:\n'
            else:
                query += f'In order to treat the patient with {disease_names}, the doctor followed clinical practice guidelines, which instructed him to do the following:\n'
            # Iterate over the graph for the selected disease taking decisions that optimizer made
            while cur_idx < len(self.optimizer_result[disease]):
                cur_revision_id = self.graph.get_revision_id(self.optimizer_result[disease][cur_idx])
                # Do not append query if the action is not a revision action
                if cur_revision_id is None:
                    if self.graph.is_action_node(self.optimizer_result[disease][cur_idx]) or not skip_decisions:
                        query += f"{cur_idx + 1}. {self.graph.get_action(self.optimizer_result[disease][cur_idx])['title']}\n"
                else:
                    revision_query = ""
                    # Keep iterating over the selected path until actions specified in the same revision end
                    while cur_idx < len(self.optimizer_result[disease]) and self.graph.get_revision_id(self.optimizer_result[disease][cur_idx]) == cur_revision_id:
                        revision_query += f"{cur_idx + 1}. {self.graph.get_action(self.optimizer_result[disease][cur_idx])['title']}\n"
                        cur_idx += 1
                        queries.append(
                            query
                            + 'Then the doctor decided to do the following:\n'
                            + revision_query
                            + 'Can you explain why the doctor decided to do this? Were there any side effects that afftected their decision?'
                        )
                    # Add the query so far with the revision actions to the list of queries
                    query += revision_query
                cur_idx += 1
        return queries
    
    def generate_patient_data_query(self):
        '''
        Generate the part of the LLM query with patient data.
        '''
        patient_data = json.load(open(self.patient_datafile, encoding="utf-8"))
        self.patient_data_query = "The doctor treats a specific patient. We know the following information about patient's health:\n"
        for observation in patient_data:
            for component in observation["component"]:
                if component["code"]["coding"][0]["system"] == "mitplan":
                    self.patient_data_query += f"{component['value']['valueString']}\n"
        return self.patient_data_query
