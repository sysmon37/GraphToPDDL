# FHIR integration

This folder contains a modified version of GraphToPDDL which is integrated with FHIR standard. The structure is as follows:
* `ActionGraph.py` - the main graph object with all clinical actions.
* `Constants.py` - constant values used by other scripts.
* `GraphToPDDL.py` - conversion of action graphs into PDDL problems.
* `RevisionOperators.py` - support for revision operators and applying them to the graph.
* `MitPlan.py` - the main class that ties every other part of MitPlan together.
* `example.py` - a simple script showing how you can MitPlan.
* `examples` - examples of FHIR resources used by MitPlan.

### Adding edges between nodes

Edges are added between the nodes using `relatedAction` parameter inside of the action in either PlanDefinition or RequestOrchestration. The action connected to the current action must be put into the `targetId` field. It takes in a list of edges, where the following applies:
```json
relatedAction: [{"targetId": "target", "relationship": "after"}]
```
will create a connection going out of the current node and into the `"target"` node (which means, the target is to be executed **after** the current action).

```json
relatedAction: [{"targetId": "target", "relationship": "before"}]
```
will create a connection going into the current node and out of the `"target"` node (which means, the target is to be executed **before** the current action).

### Adding conditions and decision nodes

In order to create a decision node, a child of a decision node needs to have a `condition` field inside of its action in PlanDefinition. This field has a list of conditions, where each condition needs to have an `expression` that contains the name of the decision node and the value that it needs to take for this action to be taken. This expression must also have a `language` field which will take the value of `"text/mitplan"`.

```json
"condition": [
    {
        "kind": "applicability",
        "expression": {
            "language": "text/mitplan",
            "expression": "RENALFAILURE 1..10"
        }
    }
]
```
The code snippet above, when placed into action A, will cause the node called `RENALFAILURE` to become a decision node, with a new edge going into action A with an indication that it is to be executed if `RENALFAILURE` takes the values in range between `1` and `10`.

### Render as .png
It is possible to render a graph into a .png file. The fromats for all graph nodes on the image are available in the `Constants.py` file, in the `FORMAT_OPTIONS` variable, grouped by node types. When rendered, each node will take the value of the `title` field, or if not present, the value of `id` field.

The edges going out of decision nodes will take the values of `expression` in the condition definition.

### Adding revision operators
Revision operators are handled by `RevisionOperators.py` file. This file takes in a `json` file, which needs to contain a list of DetectedIssue resources inside of a `revision_declarations` field and a list of RequestOrchestration resources inside of the `revision_definitions` field.

In order to specify nodes that trigger a revision use `implicated` field and place id of the nodes that trigger a revision in the `reference` field of each element in the list, like so:
```json
"implicated" : [
    { "reference" : "DOAC" },
    { "reference" : "CCB" }
]
```
Which will trigger the revision if both nodes with id `DOAC` and `CCB` are present in the graph.

The RequestOrchestration triggered by the revision must be put inside of the `mitigation` key. There you need to put **at most** 1 action, which should have the following structure:
```json
"mitigation": [
    {
        "action" : {
            "coding" : [{
            "system" : "local",
            "code" : "revision_definition_id",
            "display" : "Drug conflict"
            }],
            "text" : "Replace node with node"
        },
        "note": "target"
    }
]
```
When the revision with the above snippet is triggered, it will call RequestOrchestration with id equal to `revision_definition_id`. It will then replace the node with id equal to `target`.

If you would like to **replace** a node, specify a target to replace using `note` field and the RequestOrchestration to replace it within the `code` field.

If you would like to **add** a node, specify a RequestOrchestration to add within the `code` field, but do not use the `note` field.

If you wouuld like to **delete** a node. specify a node to delete using `note` field, but do not use `action` field.

When triggering a revision with RequestOrchestration, all the actions inside of the RequestOrchestration (in the `action` field) will be added to the original graph. All the rules for adding decision nodes and edges are the same as for the regular `ActionGraph`.

### Generating LLM queries

As a part of the system, it is possible to generate queries for Large Language Models. These can be used to generate explanations for revision operations chosen by the optimizer.

In order to generate them you can use `generate_queries` and `generate_patient_data_query` methods in `MitPlan.py`. The first method will generate queries containing only the actions chosen by the optimizer. It takes in two parameters:
- `skip_decisions`, which will omit decision nodes when traversing a graph during query generation (it will only contain action and revision nodes) [`True` by default]
- `include_other_plans`, which will add actions chosen by the optimizer for other diseases solved by the MitPlan to the beginning of the query [`False` by default]

The `generate_patient_data_query` will generate a part of the LLM query containing patient data listed in enumerated list.

Remember that `generate_queries` will run rewrite-no-lp optmizer **first**. The optimizer assumes you are running MitPlan on a **UNIX** machine. The command it runs is as follows:

```bash
./rewrite-no-lp --optimise {DOMAIN_NAME}.pddl {PROBLEM_NAME}.pddl
```

So remember to put rewrite-no-lp script into the directory where `MitPlan.py` is present! If you need to change this command edit the `command` variable inside of the `generate_queries` method in `MitPlan.py` file. If the function doesn't return anything, then it means that either the optimizer couldn't find a solution or there was an error during the execution of the command. You can use the `error` variable inside of the `run_optimizer` function in `MitPlan.py` to see where the error is, or just list all lines in the for loop.
