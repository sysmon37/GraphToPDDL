# NetworkX Overview

## Requirements

- Python 3.9.X
- graphviz (python librairy & graphviz package)
- networkx (python librairy)

## Installation

Graphhviz can be installed from [Graphviz](https://graphviz.org/download/)

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install requirements.

```bash
pip install -r requirements.txt
```

## Execute GraphToPDDL

````bash
python script.py
````
````shell
./script.py AG.dot --ro RO.json --patient-values.json
````

### Commands
The current implementation required an actionnable graph, a revision_operator json file and a patient_values json file.

#### Actionnable Graph

#### Revision Operators
More info: [Revision operators](../UseCases/Revision_Operators/readme.md)

#### Patient Values

## Structure Overview

│   create_RO.py    <br />
│   └─── Revision Operators creator    <br />
│   DotGraphCreator.py    <br />
│   └─── Graphical output class    <br />
│   input_output_graph.py    <br />
│   └─── Create a graph from a dot structure    <br />
│   input_RO.py    <br />
│   └─── Revision Operators reader functions    <br />
│   problem.pddl    <br />
│   └─── PDDL output of the problem    <br />
│   problem.png    <br />
│   └─── Graphical output of the problem    <br />
│   readme.md    <br />
│   └─── This file    <br />
│   script.py    <br />
│   └─── Main program to lauch GraphToPDDL    <br />
│   test.ipynb    <br />
│   └─── Jupyter Notebook use for experimentation    <br />
│   test-problem.pddl    <br />
│   └─── Used by the test case    <br />
│   test_problem_file.py    <br />
│   └─── PyTest unit test case    <br />
│   utils.py    <br />
│   └─── Modules used by the automation    <br />
│   write_pddl.py    <br />
│   └─── Functions used to create and write a PDDL output    <br />
│   __init__.py    <br />
│   └─── Module    <br />


