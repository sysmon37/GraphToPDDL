class Node:
    def __init__(self, label):
        self.label = label
        self.in_edges = []
        self.out_edges = []

    def add_in_edge(self, edge):
        # could do some validation if needed?
        # e.g. if(edge.to_node == self?)
        self.in_edges.append(edge)

    def add_out_edge(self, edge):
        # could do some validation if needed?
        # e.g. if(edge.to_node == self?)
        self.out_edges.append(edge)
