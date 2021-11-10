from input_output_graph import outputGraphViz, read_graph
from write_pddl import outputPDDL
from input_RO import read_RO, update_graph_with_ROs
import argparse as ap


def run(
    path="../UseCases/AGFigures/testcase-5-rev.dot",
    ros_path="../UseCases/Revision_Operators/testcase-5-ro.json",
):
    """
    Function to run the automation pipeline.

    Args:
        path (str): Path to the file.
        ros_path (str): Path to the revision operators file.

    """
    graph = read_graph(path)
    ros = read_RO(ros_path)
    update_graph_with_ROs(graph, ros)
    outputPDDL(graph, ros, "problem-test", "domain_test")
    outputGraphViz(graph)


if __name__ == "__main__":
    parser = ap.ArgumentParser()
    parser.add_argument(
        "--ag", type=str, help="Path to the AG file. It must be a DOT file."
    )
    parser.add_argument(
        "--agx", type=str, help="Path to the Extended AG file. It must be a DOT file."
    )
    parser.add_argument(
        "--ro",
        type=str,
        help="Path to the revision operator file. It must be a JSON file.",
    )
    args = parser.parse_args()
    try:
        if not args.ag and not args.agx:
            raise Exception(
                "An AG (extended or not) file is needed. Please use the flag --ag or --agx followed by the path to the file.\nUse the flag -h for more information"
            )

        if args.ag and args.ag[-3:].lower() != "dot":
            raise Exception("The AG file (--ag) must be a DOT file.")

        if args.agx and args.agx[-3:].lower() != "dot":
            raise Exception("The AG file (--agx) must be a DOT file.")

        if not args.ro:
            raise Exception(
                "A Revision Operators file is needed. Please use the flag --ro followed by the path to the file.\nUse the flag -h for more information"
            )

        if args.ro[-4:].lower() != "json":
            raise Exception("The Revision operators file (--ro) must be a JSON file.")

        run(
            args.ag,
            args.ro,
        )
    except Exception as e:
        print(e)
