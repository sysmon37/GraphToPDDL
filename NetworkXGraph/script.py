from input_output_graph import outputGraphViz, read_graph
from write_pddl import outputPDDL
from input_RO import read_RO, update_graph_with_ROs


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
    run(
        "../UseCases/AGFigures/testcase-5-rev.dot",
        "../UseCases/Revision_Operators/testcase-5-ro.json",
    )
