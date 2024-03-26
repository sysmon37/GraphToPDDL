from ActionGraph import ActionGraph
from RevisionOperators import RevisionOperators
from GraphToPDDL import GraphToPDDL

# An example script showing how to use MitPlan

if __name__ == "__main__":
    graph = ActionGraph()
    ro = RevisionOperators()
    # Add PlanDefinitions to the graph
    graph.add_fhir_actions("plan-definition-dvt.json")
    graph.add_fhir_actions("plan-definition-scad.json")
    graph.update_graph()
    # Create revision operators
    ro.add_fhir_revision_operators("ro-dvt-scad-short.json")
    ro.update_revision_operators()
    # Apply revision operators to the graph
    ro.apply_to_graph(graph)
    # Render the graph into the .png file
    graph.render_graphviz(graph.nwx2graphviz())
    # Convert ActionGraph into PDDL
    g2pddl = GraphToPDDL("mitplan-problem", "mitplan-domain", graph.graph, ro)
    g2pddl.write_pddl("mitplan-problem.pddl")
