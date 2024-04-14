from MitPlan import MitPlan

# An example script showing how to use MitPlan

if __name__ == "__main__":
    mp = MitPlan(
        # PlanDefinitions
        ["plan-definition-mdd.json", "plan-definition-alzheimer.json"],
        # Revision operators
        ["ro-ad-mdd.json"],
        # Patient data
        "data-ad-mdd.json",
        # PDDL problem name
        "mitplan-problem",
        # PDDL domain name
        "mitplan-domain"
    )
    # You can add more PlanDefinitions using the add_plan_file method or a new revision using add_revision_file
    # then just call create_graph method to recreate the graph
    mp.create_graph()
    # Render the graph into png file (mitplan-graph.png)
    mp.render_graph(filename="mitplan-graph", output_dir=".")
    # Generate pddl problem file (mitplan-problem.pddl)
    mp.generate_pddl()
    # Generate LLM queries
    queries = mp.generate_queries(skip_decisions=False, include_other_plans=True)
    print(queries)
    print(mp.generate_patient_data_query())
