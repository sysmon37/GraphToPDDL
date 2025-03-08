Instance: PlanCKD
InstanceOf: PlanDefinition
* name = "CKD_Plan"
* title = "Plan to treat Chronic Kidney Disease"
* status = #active
* action[0]
  * id = "start-ckd"
  * title = "Start treatment"
  * relatedAction[0]
    * targetId = "ckd-egfr"
    * relationship = #after

* action[1]
  * id = "ckd-egfr"
  * title = "eGFR level < 60?"
  * relatedAction[0]
    * targetId = "ckd-hemoglobin"
    * relationship = #after
  * relatedAction[1]
    * targetId = "ckd-ace-inhibitor"
    * relationship = #after
  * relatedAction[2]
    * targetId = "ckd-aspirin"
    * relationship = #after
  * relatedAction[3]
    * targetId = "ckd-lifestyle-management"
    * relationship = #after

* action[2]
  * id = "ckd-hemoglobin"
  * title = "Hemoglobin level < 100?"
  * relatedAction[0]
    * targetId = "ckd-ferritin"
    * relationship = #after
  * relatedAction[1]
    * targetId = "ckd-esa"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-egfr 1..1"

* action[3]
  * id = "ckd-ferritin"
  * title = "Ferritin level < 100?"
  * relatedAction[0]
    * targetId = "ckd-iron"
    * relationship = #after
  * relatedAction[1]
    * targetId = "ckd-metabolic-abnormality"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-hemoglobin 0..0"

* action[4]
  * id = "ckd-esa"
  * title = "ESA"
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-hemoglobin 1..1"
  * relatedAction[0]
    * targetId = "ckd-ferritin"
    * relationship = #after

* action[5]
  * id = "ckd-iron"
  * title = "Oral iron therapy"
  * relatedAction[0]
    * targetId = "ckd-metabolic-abnormality"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-ferritin 1..1"

* action[6]
  * id = "ckd-metabolic-abnormality"
  * title = "Metabolic abnormality present?"
  * relatedAction[0]
    * targetId = "ckd-phosphate-binders"
    * relationship = #after
  * relatedAction[1]
    * targetId = "ckd-ace-inhibitor"
    * relationship = #after
  * relatedAction[2]
    * targetId = "ckd-aspirin"
    * relationship = #after
  * relatedAction[3]
    * targetId = "ckd-lifestyle-management"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-ferritin 0..0"

* action[7]
  * id = "ckd-phosphate-binders"
  * title = "Phosphate binders"
  * relatedAction[0]
    * targetId = "ckd-ace-inhibitor"
    * relationship = #after
  * relatedAction[1]
    * targetId = "ckd-aspirin"
    * relationship = #after
  * relatedAction[2]
    * targetId = "ckd-lifestyle-management"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-metabolic-abnormality 1..1"

* action[8]
  * id = "ckd-ace-inhibitor"
  * title = "ACE inhibitor"
  * relatedAction[0]
    * targetId = "goal-ckd"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-metabolic-abnormality 0..0"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-egfr 0..0"
      

* action[9]
  * id = "ckd-aspirin"
  * title = "Low dose aspirin"
  * relatedAction[0]
    * targetId = "goal-ckd"
    * relationship = #after
  * relatedAction[0]
    * targetId = "goal-ckd"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-metabolic-abnormality 0..0"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-egfr 0..0"

* action[10]
  * id = "ckd-lifestyle-management"
  * title = "Lifestyle management for CKD"
  * relatedAction[0]
    * targetId = "goal-ckd"
    * relationship = #after
  * relatedAction[0]
    * targetId = "goal-ckd"
    * relationship = #after
  * condition[0]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-metabolic-abnormality 0..0"
  * condition[1]
    * kind = #applicability
    * expression
      * language = #mitplan
      * expression = "ckd-egfr 0..0"

* action[11]
  * id = "goal-ckd"
  * title = "End treatment"
