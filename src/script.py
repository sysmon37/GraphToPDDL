from src.utils import handle_alternative_nodes
from src.input_output_graph import outputGraphViz, read_graph
from src.input_output_graph import read_graph
from src.write_pddl import outputPDDL
from src.input_RO import read_JSON, update_graph_with_ROs
from src.layer3 import processLayer3

import argparse as ap
import traceback


def run(
    path, ros_path, patient_values_path, no_ro, problem_name, domain_name, output_dir
):
    """
    Function to run the automation pipeline.

    Args:
        path (str): Path to the file.
        ros_path (str): Path to the revision operators file.
        patient_values_path (str): Path to the patient values file.

    """
    graph = read_graph(path)

    # ROs
    ros = []
    if no_ro:
        print("Revision operators will not be applied.")

    elif ros_path:
        ros = read_JSON(ros_path)
        update_graph_with_ROs(graph, ros)
    else:
        print("No revision operators file provided.")

    # Patient values
    if patient_values_path:
        patient_values = read_JSON(patient_values_path)
    else:
        patient_values = {}
        print("No patient values file provided.")

    handle_alternative_nodes(graph)
    outputPDDL(graph, ros, patient_values, problem_name, domain_name, output_dir)
    outputGraphViz(graph, problem_name, output_dir)

    # We temporarily block processing layer 3
    # processLayer3(graph)
