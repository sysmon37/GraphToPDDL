Instance: PlanHTN
InstanceOf: PlanDefinition
* name = "HTN_Plan"
* title = "Plan to treat Hypertension"
* status = #active
* action[+]
  * id = "start-htn"
  * title = "Start treatment"
  * relatedAction[+]
    * targetId = "htn-age"
    * relationship = #after

* action[+]
  * id = "htn-age"
  * title = "Age < 55?"
  * relatedAction[0]
    * targetId = "htn-ccb-1"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-ace-inhibitor-1"
    * relationship = #after

* action[+]
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

* action[+]
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

* action[+]
  * id = "htn-bp-controlled-1"
  * title = "BP controlled?"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * relatedAction[1]
    * targetId = "htn-ace-inhibitor-2"
    * relationship = #after

* action[+]
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

* action[+]
  * id = "htn-bp-controlled-2"
  * title = "BP controlled?"
  * relatedAction[0]
    * targetId = "goal-htn"
    * relationship = #after
  * relatedAction[+]
    * targetId = "htn-ace-inhibitor-3"
    * relationship = #after

* action[+]
  * id = "htn-ace-inhibitor-3"
  * title = "ACE inhibitor"
  * relatedAction[+]
    * targetId = "htn-bp-controlled-3"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "htn-bp-controlled-2 0..0"

* action[+]
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

* action[+]
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

* action[+]
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
