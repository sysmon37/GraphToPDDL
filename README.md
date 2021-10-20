# GraphToPDDL

## Sections
[Requirements](#Requirements)<br>
[Documentations](#Documentations)<br>
[Python Environment](#Python-graphToPDDL-environment)<br>
[Module Execution](#Execute-individual-modules)<br>

## Requirements
- Python 3.9.X
- graphviz
- pydot
- networkx

## Documentations
- [graphviz python api](https://graphviz.readthedocs.io/en/stable/manual.html)

## Python graphToPDDL environment
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

## Execute individual modules
### GraphComponent
````
python -m GraphComponent.graph
````

## Execute the project
````
python main.py dotFile
````
>dotfile is the path to the corresponding file.
> e.g. : python main.py UseCases\AGFigures\\testcase-5.dot