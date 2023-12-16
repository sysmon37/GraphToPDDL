from src.utils import handle_alternative_nodes
from src.input_output_graph import outputGraphViz, read_graph
from src.input_output_graph import read_graph
from src.write_pddl import outputPDDL
from src.input_RO import read_JSON, update_graph_with_ROs
from src.layer3 import processLayer3

import argparse as ap
import traceback

def read_graph_and_ros(path, ros_path):
    """
    Reads graph and ROs and applies ROs to the graph. Returns the revised graph.
    """

    graph = read_graph(path)

    # ROs
    ros = []
    if ros_path:
        ros = read_JSON(ros_path)
        update_graph_with_ROs(graph, ros)
    else:
        print("No revision operators provided.")

    return graph, ros


# Run conversion to PDDL
def run_to_pddl(
    path, ros_path, patient_values_path, problem_name, domain_name, output_dir
):
    """
    Function to run the automation pipeline.

    Args:
        path (str): Path to the file.
        ros_path (str): Path to the revision operators file.
        patient_values_path (str): Path to the patient values file.

    """
    graph, ros = read_graph_and_ros(path, ros_path)

    # Patient values
    if patient_values_path:
        patient_values = read_JSON(patient_values_path)
    else:
        patient_values = {}
        print("No patient values file provided.")

    handle_alternative_nodes(graph)
    outputPDDL(graph, ros, patient_values, problem_name, domain_name, output_dir)
    outputGraphViz(graph, problem_name, output_dir)


def run_to_plan_diff(path, ros_path, base_path, opt_path):

    graph, _ = read_graph_and_ros(path, ros_path)
    processLayer3(graph, base_path, opt_path)
