Instance: PlanHTN
InstanceOf: PlanDefinition
* name = "HTN_Plan"
* title = "Plan to treat Hypertension"
* status = #active
* action[0]
  * id = "start-htn"
  * title = "Start treatment"
  * relatedAction[0]
    * targetId = "htn-age"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-lifestyle-management"
    * relationship = #after

* action[1]
  * id = "htn-age"
  * title = "Age < 55?"
  * relatedAction[0]
    * targetId = "htn-ccb-1"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-ace-inhibitor-1"
    * relationship = #after

* action[2]
  * id = "htn-lifestyle-management"
  * title = "Lifestyle management for HTN"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after

* action[3]
  * id = "htn-ccb-1"
  * title = "CCB"
  * relatedAction[0]
    * targetId = "htn-bp-controlled-1"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-age 0..0"

* action[4]
  * id = "htn-ace-inhibitor-1"
  * title = "ACE inhibitor"
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-age 1..1"
  * relatedAction[0]
    * targetId = "htn-bp-controlled-1"
    * relationship = #after

* action[5]
  * id = "htn-bp-controlled-1"
  * title = "BP controlled?"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-ace-inhibitor-2"
    * relationship = #after
  * relatedAction[2]
    * targetId = "htn-diuretic-1"
    * relationship = #after

* action[6]
  * id = "htn-ace-inhibitor-2"
  * title = "ACE inhibitor"
  * relatedAction[0]
    * targetId = "htn-bp-controlled-2"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-1 0..0"

* action[7]
  * id = "htn-diuretic-1"
  * title = "Diuretic"
  * relatedAction[0]
    * targetId = "htn-bp-controlled-2"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-1 0..0"

* action[8]
  * id = "htn-bp-controlled-2"
  * title = "BP controlled?"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-ace-inhibitor-3"
    * relationship = #after
  * relatedAction[2]
    * targetId = "htn-ccb-2"
    * relationship = #after
  * relatedAction[3]
    * targetId = "htn-diuretic-2"
    * relationship = #after
  * relatedAction[4]
    * targetId = "htn-bp-controlled-3"
    * relationship = #after

* action[9]
  * id = "htn-ace-inhibitor-3"
  * title = "ACE inhibitor"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-2 0..0"

* action[10]
  * id = "htn-ccb-2"
  * title = "CCB"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-2 0..0"

* action[11]
  * id = "htn-diuretic-2"
  * title = "Diuretic"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-2 0..0"

* action[12]
  * id = "htn-bp-controlled-3"
  * title = "BP controlled?"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-specialist-consult"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-2 0..0"

* action[13]
  * id = "htn-specialist-consult"
  * title = "Consult a specialist"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-3 0..0"

* action[14]
  * id = "goal-htn"
  * title = "End treatment"
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-1 1..1"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-2 1..1"
  * condition[2]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-3 1..1"
