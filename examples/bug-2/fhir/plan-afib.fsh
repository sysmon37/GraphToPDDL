Instance: PlanAFIB
InstanceOf: PlanDefinition
* name = "AFib_Plan"
* title = "Plan to treat Atrial Fibrilation"
* status = #active
* action[0]
  * id = "start-afib"
  * title = "Start treatment"
  * relatedAction[0]
    * targetId = "afib-warfarin-or-doac"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-special-circumstances"
    * relationship = #after

* action[1]
  * id = "afib-warfarin-or-doac"
  * title = "Warfarin or DOAC"
  * relatedAction[0]
    * targetId = "goal-afib"
    * relationship = #after

* action[2]
  * id = "afib-special-circumstances"
  * title = "Special circumstances?"
  * relatedAction[0]
    * targetId = "afib-bb-ccb-digoxin"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-type"
    * relationship = #after

* action[3]
  * id = "afib-bb-ccb-digoxin"
  * title = "BB or CCB or Digoxin"
  * relatedAction[0]
    * targetId = "afib-symptoms-resolve"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-special-circumstances 0..0"

* action[4]
  * id = "afib-type"
  * title = "Is Atrial Fibrilation persistent?"
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-special-circumstances 1..1"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-symptoms-resolve 0..0"
  * relatedAction[0]
    * targetId = "afib-cardioversion"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-high-burden-recurrence"
    * relationship = #after

* action[5]
  * id = "afib-symptoms-resolve"
  * title = "Did symptoms resolve?"
  * relatedAction[0]
    * targetId = "afib-type"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-bb-ccb-digoxin-combination"
    * relationship = #after

* action[6]
  * id = "afib-cardioversion"
  * title = "Cardioversion"
  * relatedAction[0]
    * targetId = "afib-symptoms-improve"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-type 1..1"

* action[7]
  * id = "afib-high-burden-recurrence"
  * title = "Is there a high burden of recurrence?"
  * relatedAction[0]
    * targetId = "afib-pill-in-a-pocket"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-dronedarone-flecainide-amiodarone"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-type 0..0"

* action[8]
  * id = "afib-pill-in-a-pocket"
  * title = "Pill-in-a-pocket"
  * relatedAction[0]
    * targetId = "goal-afib"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-high-burden-recurrence 0..0"

* action[9]
  * id = "afib-symptoms-improve"
  * title = "Did symptoms improve?"
  * relatedAction[0]
    * targetId = "afib-tachycardia"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-afib-recurs"
    * relationship = #after
  * relatedAction[2]
    * targetId = "afib-bb-ccb-digoxin-combination"
    * relationship = #after

* action[10]
  * id = "afib-tachycardia"
  * title = "Tachycardia?"
  * relatedAction[0]
    * targetId = "goal-afib"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-bb-ccb-digoxin-combination"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-symptoms-improve 1..1"

* action[11]
  * id = "afib-afib-recurs"
  * title = "Atrial Fibrilation recurs?"
  * relatedAction[0]
    * targetId = "goal-afib"
    * relationship = #after
  * relatedAction[1]
    * targetId = "afib-dronedarone-flecainide-amiodarone"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-symptoms-improve 1..1"

* action[12]
  * id = "afib-bb-ccb-digoxin-combination"
  * title = "BB or CCB or Digoxin (or combination)"
  * relatedAction[0]
    * targetId = "goal-afib"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-symptoms-resolve 1..1"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-symptoms-improve 0..0"
  * condition[2]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-tachycardia 1..1"

* action[13]
  * id = "afib-dronedarone-flecainide-amiodarone"
  * title = "Dornedarone or Flecainide or Amiodarone"
  * relatedAction[0]
    * targetId = "goal-afib"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-afib-recurs 1..1"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-high-burden-recurrence 1..1"

* action[14]
  * id = "goal-afib"
  * title = "End treatment"
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-tachycardia 0..0"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "afib-afib-recurs 0..0"
