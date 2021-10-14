from node import Node


class ActionNode(Node):
    def __init__(self, label, cost=0, **kwargs):
        super().__init__(label)
        self.cost = cost

    def __str__(self):
        return "Decision node: {} with cost: {}. In: {}, Out: {}".format(
            self.label, self.cost, len(self.in_edges), len(self.out_edges)
        )
