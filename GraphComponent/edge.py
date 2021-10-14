class Edge:
    def __init__(self, from_node, to_node, label_values=None):
        self.from_node = from_node
        self.to_node = to_node
        self.label_values = label_values

    def __str__(self):
        return "Edge {} -> {} {}".format(
            self.from_node, self.to_node, self.label_values
        )
