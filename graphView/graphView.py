from graphviz import Digraph # We only need Digraph
from GraphComponent import graph
import json 

class graphView:
    def __init__(self, graph, name):
        self.graph = graph
        self.name = name

        # graph.printDot()

        self.g = Digraph(name=name)

        self.generateGraph()

        self.g.view()

        print("Graph View for", name)


    """

    
    """
    def getName(self):
        return self.name

    def getDotGraph(self):
        return self.graph

    def generateGraph(self):
        for n in self.graph.nodes:
            #print(n, graph.nodes[n])
            #print("node")
            # print(n)

            # TODO: Add shape & color attributes to nodes
            # g.attr('node', shape=graph.nodes[n].shape, color=graph.nodes[n].color)

            # TODO: Action node case , the cost label
            self.g.node(n)# Add label to the graph

            # Add Edges to the graph
            for e in self.graph.nodes[n].out_edges:
                #print("out")
                # print(e.from_node)
                # print(e.to_node)
                # print(e.label_values)
                
            
                # No label is provided
                if(e.label_values != None):
                    key = list(e.label_values.keys())[0]
                    lower_bound = list(e.label_values[key]["lower_bound"])[0]
                    upper_bound = list(e.label_values[key]["upper_bound"])[0]
            
                    str_label = "{} = [{}..{}]".format(key, lower_bound, upper_bound)
                    #print(str_label)
                    # TODO: parse label value
                    self.g.edge(e.from_node, e.to_node, label=str_label)
                else:
                    self.g.edge(e.from_node, e.to_node)
