# GraphToPDDL - MitPlan (Generation of PDDL Based on CPGs)

## Sections
- [Requirements](#requirements)
- [Installation](#installation)
- [Documentation](#documentation)
- [Execute GraphToPDDL](#execute-graphtopddl)
- [Structure Overview](#structure-overview)
- [Python GraphToPDDL environment](#python-graphtopddl-environment)


## Requirements

- Python 3.9.X
- Graphviz (python api library & graphviz package)
    - [api](https://pypi.org/project/graphviz/)
    - [Graphviz](https://graphviz.org/download/)
- NetworkX (python library)
    - [library](https://pypi.org/project/networkx/)
    - [source](https://github.com/networkx/networkx)
- pydot dependency for NetworkX 
    - [library](https://pypi.org/project/pydot/)
    - [source](https://github.com/pydot/pydot)
- pdoc
    - [library](https://pypi.org/project/pdoc/)
    - [source](https://github.com/mitmproxy/pdoc/)

## Installation

Graphhviz can be installed from [Graphviz](https://graphviz.org/download/)

Use the package manager [pip](https://pip.pypa.io/en/stable/) to install requirements.

```bash
pip install -r requirements.txt
```

## Documentation

- [graphviz python api](https://graphviz.readthedocs.io/en/stable/manual.html)
    - [Source](https://github.com/xflr6/graphviz)
- [NetworkX](https://networkx.org/documentation/stable/reference/index.html)
- [pydot](https://github.com/pydot/pydot)
- [pdoc](https://pdoc.dev/docs/pdoc.html)
- [GraphToPDDL](../docs/readme.md)

### Build the documentation

Build the documentation using the included script.
````bash
./build-docs.sh
````
The documentation can be found at [index.html](/docs/code/src/index.html)


## Execute GraphToPDDL
More info: [See](../README.md)

### Arguments
The current implementation required an actionnable graph, a revision operators json file and a patient values json file.

#### Actionnable Graph
More info: [Actionable graph](../UseCases/Dot_files/readme.md)

#### Revision Operators
More info: [Revision operators](../UseCases/Revision_Operators/readme.md)

#### Patient Values
More info: [Patient values](../UseCases/PatientValues/readme.md)

#### Docker Container for Optic
More info: [Build Docker image](../Optic-Docker/README.md)

## Structure Overview

│   CONSTANT.py    <br />
│   └─── All the various constants used   <br />
│   DotGraphCreator.py    <br />
│   └─── Graphical output class    <br />
│   input_output_graph.py    <br />
│   └─── Create a graph from a dot structure    <br />
│   input_RO.py    <br />
│   └─── Revision Operators reader functions    <br />
│   problem.pddl    <br />
│   └─── PDDL output of the problem (When generated)    <br />
│   problem.png    <br />
│   └─── Graphical output of the problem (When generated)   <br />
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
│   build-docs.sh    <br />
│   └─── Script to build code documentation    <br />
│   __init__.py    <br />
│   └─── Module    <br />


## Python GraphToPDDL environment
### Creating Python environment
````
python -m venv .graphToPDDL
````

### Activating the Python graphToPDDL environment
````
.\.graphToPDDL\Scripts\activate
````

### Installing requirements
````
py -m pip install -r requirements.txt
````

### Deactivating the Python graphToPDDL environment
````
deactivate
````
