from utils import handle_alternative_nodes
from input_output_graph import outputGraphViz, read_graph
from write_pddl import outputPDDL
from input_RO import read_JSON, update_graph_with_ROs
import argparse as ap
import traceback


def run(
    path,
    ros_path,
    patient_values_path,
    og
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
    ros = read_JSON(ros_path)
    update_graph_with_ROs(graph, ros)
    handle_alternative_nodes(graph)

    # Patient values
    patient_values = read_JSON(patient_values_path)

    outputPDDL(graph, ros, patient_values, "problem-test", "domain_test")
    outputGraphViz(graph)


if __name__ == "__main__":
    parser = ap.ArgumentParser()
    parser.add_argument(
        "ag", type=str, help="Path to the AG file. It must be a DOT file."
    )

    parser.add_argument(
        "--ro",
        type=str,
        help="Path to the revision operator file. It must be a JSON file.",
    )
    parser.add_argument(
        "--p",
        type=str,
        help="Path to the patient values file. It must be a JSON file.",
    )

    parser.add_argument(
        "--og",
        action='store_true',
        help="Original Graph only",
    )

    args = parser.parse_args()
    try:
        if not args.ag:
            raise Exception(
                "An AG (extended or not) file is needed. Please use the flag --ag or --agx followed by the path to the file.\nUse the flag -h for more information"
            )

        if args.ag and args.ag[-3:].lower() != "dot":
            raise Exception("The AG file (--ag) must be a DOT file.")

        if args.ro != None and args.ro[-4:].lower() != "json":
            raise Exception("The Revision operators file (--ro) must be a JSON file.")

        if args.p != None and args.p[-4:].lower() != "json":
            raise Exception("The Revision operators file (--ro) must be a JSON file.")

        run(args.ag, args.ro, args.p, args.og)
    except Exception as e:
        print(e)
        traceback.print_exc()
