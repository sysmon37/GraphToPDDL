"""
File containing the constants used in this project.
"""


# Node types
CONTEXT_NODE = "context"
GOAL_NODE = "goal"
ACTION_NODE = "action"
DECISION_NODE = "decision"
PARALLEL_NODE = "parallel"
ALTERNATIVE_NODE = "alternative"

# Node attributes
ID_ATTR = "id"
IS_ORIGINAL_ATTR = "is_original"
TYPE_ATTR = "type"
DATA_ITEM_ATTR = "dataItem"
IS_IN_PARALLEL = "is_in_parallel"
IS_ALTERNATIVE = "is_alternative"
TRIGGER = "trigger"
PARALLEL_START_ATTR = "parallelStartNode"
PARALLEL_END_ATTR = "parallelEndNode"

TRIGGER_CONDITION = "triggercondition"

# Edge attributes
RANGE_ATTR = "range"

# RO operations
ADD_OPERATION = "add"
DELETE_OPERATION = "delete"
REPLACE_OPERATION = "replace"


# RO operations attributes
ID_RO = "idRO"
OPERATIONS = "operations"
NEW_NODES = "newNodes"
EXISTING_NDOE = "existingNode"
PREDECESSORS = "predecessors"
EDGE_TO_SUCCESSORS = "edgeToSuccessors"
EDGE_TO_SUCCESSORS_ATTR = "edgeToSuccessorsAttr"
SUCCESSORS = "successors"

SEQUENCE = "sequence"
OFFSET = "offset"
OFFSET_NODE = "offsetNode"
START_TIME_REF = "startTimeRef"
START_TIME_WHICH = "startTimeWhich"
START_TIME_CHANGE = "startTimeChange"
END_TIME_REF = "endTimeRef"
END_TIME_WHICH = "endTimeWhich"
END_TIME_CHANGE = "endTimeChange"
START = "start"
END = "end"

# Graph attributes
SHAPE = "shape"
FILLCOLOR = "fillcolor"
FONTCOLOR = "fontcolor"
WIDTH = "width"
HEIGHT = "height"
FIXEDSIZE = "fixedsize"

# Patient values
DEFAULT_PATIENT_VALUE = "default_value"

# Metrics
METRIC_COST = "cost"
METRIC_BURDEN = "burdenCost"
METRIC_NON_ADHERENCE = "nonAdherenceCost"
METRIC_EXEC_COST = "execCost"

# Temporal properties
TIME_START = "startTimeCost"
TIME_END = "endTimeCost"
TIME_DURATION = "durationCost"