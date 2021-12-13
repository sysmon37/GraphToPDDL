# Actionable graph

This section is a guide to create a well formatted actionable graph file.

The actionable graph is passed to the program as the first argument.

# File format
The file must be a DOT file.

## Content
 The global object should be a 'digraph' object. It can be named or not. In the following example, 'test_1' is the name of the graph, but it can be omitted.
 ```
digraph test_1 {
   ...
}
 ```

### Nodes
The structure used to declare a node is the following:

```
{node_name} [{attrbute1}={value1}, {attrbute2}={value2}, ...]
```
There is only one attribute that is needed for every type of node. The attribute is: type.

```
node1 [type=action, ...]
```

#### Attributes per type
- Alternative, Context and Goal nodes do not required any other Attributes.
- Decision nodes require the attribute 'dataItem'. It refers to the patient value that will be used to make the decision.
- Action nodes require the costs attributes, if any.

```
// Context
c1 [type=context];

// Decision
t1 [type=decision, dataItem=v1]

// Actions
a1 [type=action, cost=10];

// Goals
g1 [type=goal];
```

### Edges
The structure to declare an edge is the following:
```
{predecessor} -> {successor}

// Example
c1 -> t1

// Compressed form for multiple edges
{a1, a2} -> {a3, a4}
```

Whenever the predecessor is a decision node, a 'range' attribute must be provided.
The value of the range attribute must be of the following form: {lower_bound}..{upper_bound}. For example:
```
t1 -> a1 [range=0..4]
```
