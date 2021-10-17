from GraphComponent.node import Node


class DecisionNode(Node):
    def __init__(self, label, **kwargs):
        super().__init__(label)

    def __str__(self):
        return "Decision node: {}. In: {}, Out: {}".format(
            self.label, len(self.in_edges), len(self.out_edges)
        )
