# Revision operators

This section is a guide to create a well formatted revision operators (ROs) file.

The revision operators file is passed to the program as an argument (flag --ro).
- --ro revision_operators_file.json

## File format
The file must be a JSON file.

## Content
The global content must be an array of dictionaries
```
[{
  ...
  },
 ...
]
```
### Single revision operation
A revision operation must have the followings:
- id (str) : ID of the RO
- trigger (list of str) : List of the nodes (node IDs) triggering the RO.
- operations (list of dict) : List of operations to execute.

```
[{
  "id": "ro1",
   "trigger": ["node1","node2"],
   "operations": [{...}, ...]
},
other ROs...]
```

#### Operations
Every operation must have the followings attributes:
- type (str) : The type of the operation (3 possibilities)
- existingNode (str) : The ID of the node to replace. It must be a node already in the graph.

```
[{
  ...
   "operations": [{
       "type": "replace",
       "existingNode": "nodeX",
       // Other attributes based on the type of operation
     },
     other operations...
     ]
},
other ROs...]
```

 There are 3 possibles operations:
 - [Replace](#Replace-operation)
 - [Delete](#Delete-operation)
 - Add


 #### Replace operation

 Replacing a node X means adding a sequence of nodes where the first node and the last node have the same predecessors and successors respectivly as the node X.

 The following attribute needs to be added to the operation dictionary:

 - newNodes (list of dict) : The sequence of nodes to add to the graph.

```
 [{
   ...
    "operations": [{
        "type": "replace",
        "existingNode": "nodeX",
        "newNodes": [{...}, ...]
      },
      other operations...
      ]
 },
 other ROs...]
```
The content of a newNode dictionary has the followings attributes:
- id (str) : The ID of the new node.
- type (str) : The type of the node to add. It must be a valid type (action, decision, goal, alternative or parallel).
- predecessors (list of dict) *optional* : A list of predecessors nodes create an edge from. Each dictionary must contain an attribute 'nodeId'. The rest of the attributes will be added as attributes of the edge (e.g. range).
- edgeToSuccessors (bool) *optional* : If true, creates an edge from the new node to the successors of the node to replace. If false or not included, does nothing.
- edgeToSuccessorsAttr (dict) *optional* : Dictionary of attributes of the edge from the new node to the successors of the node to replace. For this attribute to be used, it must be combined with 'edgeToSuccessors'.

Any other attributes in this dictionary will be attributes of the new node (e.g. cost). Based on the type of the new node, the other attributes must include what is required for that type. For example, if the type of the new node is 'decision', the attributes 'dataItem'.

```
[{
   ...
    "operations": [{
        "type": "replace",
        "existingNode": "nodeX",
        "newNodes": [
          {
            "id": "newDecision",
            "type": "decision",
            "dataItem": "V5",
            "edgeToSuccessors": true,
            "edgeToSuccessorsAttr": {
              "range": "0..4"
            }
          },
          {
            "id": "newAction",
            "type": "action",
            "cost": 100,
            "predecessors": [
              {
                "nodeId": "newDecision",
                "range": "5..8"
              }
            ]
          },
        other new nodes...]
      }, other operations...]
 }, other ROs...]
```


 #### Delete operation
 The delete operation of the node X creates an edge from all the predecessors to all the successors of the node X. The node X is not fully deleted from the graph because the triggering sequence of the RO might not occur. Therefore, the node X must still be in the graph.

```
[{
   ...
    "operations": [{
        "type": "delete",
        "existingNode": "nodeX",
      },
      other operations...
      ]
 },
other ROs...]
```
