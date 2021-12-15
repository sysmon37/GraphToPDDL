URLS=[
"src/index.html",
"src/CONSTANTS.html",
"src/DotGraphCreator.html",
"src/input_output_graph.html",
"src/input_RO.html",
"src/script.html",
"src/test_problem_file.html",
"src/utils.html",
"src/write_pddl.html"
];
INDEX=[
{
"ref":"src",
"url":0,
"doc":""
},
{
"ref":"src.CONSTANTS",
"url":1,
"doc":"File containing the constant used.  Node types CONTEXT_NODE = \"context\" GOAL_NODE = \"goal\" ACTION_NODE = \"action\" DECISION_NODE = \"decision\" PARALLEL_NODE = \"parallel\" ALTERNATIVE_NODE = \"alternative\"  Node attributes ID_ATTR = \"id\" IS_ORIGINAL_ATTR = \"is_original\" TYPE_ATTR = \"type\" DATA_ITEM_ATTR = \"dataItem\" IS_IN_PARALLEL = \"is_in_parallel\" IS_ALTERNATIVE = \"is_alternative\" TRIGGER = \"trigger\" PARALLEL_START_ATTR = \"parallelStartNode\" PARLLEL_END_ATTR = \"parallelEndNode\"  Edge attributes RANGE_ATTR = \"range\"  RO operations ADD_OPERATION = \"add\" DELETE_OPERATION = \"delete\" REPLACE_OPERATION = \"replace\"  RO operations attributes ID_RO = \"idRO\" OPERATIONS = \"operations\" NEW_NODES = \"newNodes\" EXISTRING_NDOE = \"existingNode\" PREDECESSORS = \"predecessor\" EDGE_TO_SUCCESSORS = \"edgeToSuccessors\" EDGE_TO_SUCCESSORS_ATTR = \"edgeToSuccessorsAttr\" SUCCESSORS = \"successors\"  Graph attributes SHAPE = \"shape\" FILLCOLOR = \"fillcolor\" FONTCOLOR = \"fontcolor\" WIDTH = \"width\" HEIGHT = \"height\" FIXEDSIZE = \"fixedsize\"  Patient values DEFAULT_PATIENT_VALUE = \"default_value\""
},
{
"ref":"src.DotGraphCreator",
"url":2,
"doc":""
},
{
"ref":"src.DotGraphCreator.DotGraphCreator",
"url":2,
"doc":"This class creates a graphviz dot graph from a NetworkX graph. Attributes: graph (NetworkXGraph): The graph to be converted to a dot graph. dot_graph (Digraph): The dot graph created from the NetworkX graph."
},
{
"ref":"src.DotGraphCreator.DotGraphCreator.create_dot_graph",
"url":2,
"doc":"Creates a graphviz dot graph from a NetworkX graph. Args: nx_graph: NetworkX graph. Returns: graphviz dot graph.",
"func":1
},
{
"ref":"src.input_output_graph",
"url":3,
"doc":""
},
{
"ref":"src.input_output_graph.read_graph",
"url":3,
"doc":"Reads in the graph. Also pre-processes the nodes by adding is_original to the action nodes. Args: path (str): Path to the file.",
"func":1
},
{
"ref":"src.input_output_graph.outputGraphViz",
"url":3,
"doc":"Ouputs the graph to a PNG file Args: graph (networkx graph): The graph.",
"func":1
},
{
"ref":"src.input_RO",
"url":4,
"doc":""
},
{
"ref":"src.input_RO.read_JSON",
"url":4,
"doc":"Reads a JSON file and returns its content. Args: path (str): Path to the file. Returns: json: JSON object",
"func":1
},
{
"ref":"src.input_RO.update_graph_with_ROs",
"url":4,
"doc":"Excutes the operations (replace, delete, add) of every revision operators. Args: graph (networkx graph): The graph. ros (list): List of JSON like object.",
"func":1
},
{
"ref":"src.input_RO.add_all_new_nodes",
"url":4,
"doc":"Add a list of new nodes with some attributes. These nodes do not have any edges after the execution of this function. Use 'add_all_new_edges' to add the respectives edges. Args: graph (networkx graph): The graph. id_ro (str): The ID of the revision operator. trigger (list): List of triggering nodes. operation (object): The operation object.",
"func":1
},
{
"ref":"src.input_RO.add_all_new_edges",
"url":4,
"doc":"Add all the edges from the operation object. Nodes related to these edges must be added to the graph prior to this function call. Use 'add_all_new_nodes' to add the respectives nodes before calling this function. Args: graph (networkx graph): The graph. id_ro (str): The ID of the revision operator. trigger (list): List of triggering nodes. operation (object): The operation object.",
"func":1
},
{
"ref":"src.input_RO.replace_operation",
"url":4,
"doc":"Replace operation inserts a sequence of new nodes. This function is a 2-steps process. First, we add all the nodes to be added. Secondly, we add all the edges. This allows the RO file to have the nodes in any particular order. Args: graph (networkx graph): The graph. id_ro (str): The ID of the revision operator. trigger (list): List of triggering nodes. operation (object): The operation object",
"func":1
},
{
"ref":"src.input_RO.delete_operation",
"url":4,
"doc":"Deletes a node. Links its predecessors and successors together. Args: graph (networkx graph): The graph. operation (str): The operation object",
"func":1
},
{
"ref":"src.input_RO.add_operation",
"url":4,
"doc":"Add operation inserts a node(s) between a list of predeccessors and successors. Args: graph (networkx graph): The graph. idRO (str): The ID of the revision operator. trigger (list): List of triggering nodes. operation (str): The operation object",
"func":1
},
{
"ref":"src.script",
"url":5,
"doc":""
},
{
"ref":"src.script.run",
"url":5,
"doc":"Function to run the automation pipeline. Args: path (str): Path to the file. ros_path (str): Path to the revision operators file. patient_values_path (str): Path to the patient values file.",
"func":1
},
{
"ref":"src.test_problem_file",
"url":6,
"doc":""
},
{
"ref":"src.test_problem_file.test_problem_file",
"url":6,
"doc":"",
"func":1
},
{
"ref":"src.utils",
"url":7,
"doc":""
},
{
"ref":"src.utils.get_type_nodes",
"url":7,
"doc":"Retrieves list of nodes of the given type Args: graph (networkx graph): The graph. node_type (str): Type of the nodes to retrieve. Returns: list: List of node of the given type.",
"func":1
},
{
"ref":"src.utils.find_goal_node",
"url":7,
"doc":"Finds a goal node recursively from a given start_node. Goal node MUST NOT have any out edges. Args: graph (networkx graph): The graph. start_node (str): Node to start the search. Returns: str: Name of the goal node.",
"func":1
},
{
"ref":"src.utils.find_init_node",
"url":7,
"doc":"Finds a initial node recursively from a given start_node. Initial node MUST NOT have any in edges. Args: graph (networkx graph): The graph. start_node (str): Node to start the search. Returns: str: Name of the goal node.",
"func":1
},
{
"ref":"src.utils.get_metric_name",
"url":7,
"doc":"Extract the name of the metric. Metrics are node attributs that contains the word 'Cost'. Args: metric (str): The metric. Returns: str: Name of the metric.",
"func":1
},
{
"ref":"src.utils.get_all_parallel_nodes",
"url":7,
"doc":"Finds all the nodes involved in parallel paths. Args: graph (networkx graph): The graph. Returns: list: List of parallel nodes.",
"func":1
},
{
"ref":"src.utils.get_number_parallel_paths",
"url":7,
"doc":"Finds the number of parallel paths. Args: graph (networkx graph): The graph. Returns: int: Number of parallel paths.",
"func":1
},
{
"ref":"src.utils.find_parallel_path",
"url":7,
"doc":"Finds all parallel paths from a list of parallel nodes. Args: graph (networkx graph): The graph. p_nodes_found (list): List of parallel start and end nodes. Returns: str: PDDL representation of the parallel path.",
"func":1
},
{
"ref":"src.utils.update_between_parallel_nodes",
"url":7,
"doc":"Updates the PDDL representation of the parallel nodes between a parallel start node and a parallel end node. Args: graph (networkx graph): The graph. start_node (str): Start node of the parallel path, Parallel Start Node. end_node (str): End node of the parallel path, Parallel End Node. parallelTypeNode (str): PDDL representation of the parallel node. untraversedParallelNode (str): PDDL representation of the untraversed parallel node. numParallelPaths (int): Number of parallel paths. Returns: str: PDDL representation of the parallel nodes.",
"func":1
},
{
"ref":"src.utils.get_all_metrics",
"url":7,
"doc":"Finds all the metrics. Metrics are node attributs that contains the word 'Cost'. Args: graph (networkx graph): The graph. Returns: list: List of metrics.",
"func":1
},
{
"ref":"src.utils.get_all_revIds",
"url":7,
"doc":"Finds all revision IDs. Args: graph (networkx graph): The graph. Returns: list: List of revision IDs.",
"func":1
},
{
"ref":"src.utils.find_revId_involved_nodes",
"url":7,
"doc":"Finds all the nodes involved in a given revision ID. This includes the list of triggering nodes and the inserted nodes Args: graph (networkx graph): The graph. revId (str): The revision ID. Returns: list: List of node's name.",
"func":1
},
{
"ref":"src.utils.match_nodes_to_disease",
"url":7,
"doc":"For each disease, find the revision operators that involve the disease. Format of the return object: { \"disease1\": ['ro1', 'ro2'],  . } Args: graph (networkx graph): The graph. Returns: object: Object where the keys are the diseases and the values are a list of revision operations IDs.",
"func":1
},
{
"ref":"src.utils.handle_alternative_nodes",
"url":7,
"doc":"Modifies the alternative nodes to decision nodes where all successors have the same edges value. That way, the planner will look into all successors for an optimize solution. The patient values provided should include a value called \"default\" with the value of 0 or 1 that will be used for the alternative nodes. Args: graph (networkx graph): The graph.",
"func":1
},
{
"ref":"src.write_pddl",
"url":8,
"doc":""
},
{
"ref":"src.write_pddl.write_objects",
"url":8,
"doc":"Writes the objects (disease, node and revId) to the file. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_initial_state",
"url":8,
"doc":"Writes all the predicates of the initial (:init) state to the file. Calls a subfunction for each predicates in the initial state Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file. ros (list) : List of revision operators. patient_values (dict) : Dictonary of the patient values.",
"func":1
},
{
"ref":"src.write_pddl.write_predecessors_and_node_type",
"url":8,
"doc":"Write the following predicates to the file: - predecessorNode - originalAction - node type (e.g. actionNode) - revisionAction - parallelStartNode - parallelEndNode - parallel node type - untraversedParallelNode Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_total_metrics",
"url":8,
"doc":"Writes the total metrics predicates. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_tentative_goal_count",
"url":8,
"doc":"Writes the tentative goal count predicate. Currently is hardcoded to 0. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_decision_branch",
"url":8,
"doc":"Writes the decision branch min/max predicates (e.g. decisionBranchMax). Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_node_cost",
"url":8,
"doc":"Writes node costs predicates. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_not_previous_node",
"url":8,
"doc":"Writes the no previous predicates (e.g: noPreviousDecision). Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_goal",
"url":8,
"doc":"Writes treatment plan ready predicate in the goal section of the PDDL file. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_metric",
"url":8,
"doc":"Writes the metric section of the PDDL file with all the metrics found in the graph. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_all_revisions_pass",
"url":8,
"doc":"Writes all revision pass predicate. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_revision_flags",
"url":8,
"doc":"Writes treatment plan ready predicate in the goal section of the PDDL file. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file. ros (list) : The list of revision operator objects",
"func":1
},
{
"ref":"src.write_pddl.write_num_revision_Ids",
"url":8,
"doc":"Writes the numRevisionIDs predicate to the PDDL file. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file.",
"func":1
},
{
"ref":"src.write_pddl.write_patient_values",
"url":8,
"doc":"Writes the patient value predicate. There is one predicate per successor each decision node. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file. patient_values (dict) : Dictonary of the patient values.",
"func":1
},
{
"ref":"src.write_pddl.write_any_no_revision_ops",
"url":8,
"doc":"Writes anyRevisionOps or noRevsionOps predicates. Args: graph (networkx graph): The graph. file (TextIOWrapper): The PDDL file. ros (list) : The list of revision operator objects",
"func":1
},
{
"ref":"src.write_pddl.outputPDDL",
"url":8,
"doc":"Ouputs the PDDL file. Args: graph (networkx graph): The graph. ros (list) : The list of revision operator objects patient_values (dict) : Dictonary of the patient values. problem_name (str): The name of the problem to be in the PDDL file. domain_name (str): The name of the domain to be in the PDDL file.",
"func":1
}
]