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
...
]
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
       "existingNode": "newNodeID",
       // Other attributes based on the type of operation
     },
     ...
     ]
},
...
]
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
        "existingNode": "newNodeID",
        "newNodes": [{...}, ...]
      },
      ...
      ]
 },
 ...
 ]
 ```

 #### Delete operation
 The delete operation of the node X creates an edge from all the predecessors to all the successors of the node X. The node X is not fully deleted from the graph because the triggering sequence of the RO might not occur. Therefore, the node X must still be in the graph.
