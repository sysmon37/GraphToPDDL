CodeSystem: RevisionDeclarations
* #replacepcb "rev-replace-pcb" "Custom MitPlan syntax"
* #replaceaspirin "rev-replace-aspirin" "Custom MitPlan syntax"
* #removebb "remove-bb" "Custom MitPlan syntax"

Instance: RemoveBB
InstanceOf: DetectedIssue
* id = "ro-remove-bb"
* status = #final
* implicated[0]
  * reference = "ckd-ace-inhibitor"
* mitigation[0]
  * action
    * text = "Remove BB and CCB due to conflict with ACE inhibitors"
    * coding[0]
      * system = "local"
      * code = #removebb
      * display = "Drug conflict"
  * note
    * text = "afib-bb-ccb-digoxin-combination"

Instance: ReplacePCB
InstanceOf: DetectedIssue
* id = "ro-replace-pcb"
* status = #final
* implicated[0]
  * reference = "start-ckd"
* mitigation[0]
  * action
    * coding[0]
      * system = "local"
      * code = #replacepcb
      * display = "Drug conflict"
    * text = "Replace amiodarone with SCB due to conflict with CKD"
  * note
    * text = "afib-dronedarone-flecainide-amiodarone"

Instance: ReplaceAspirin
InstanceOf: DetectedIssue
* id = "ro-replace-aspirin"
* status = #final
* implicated[0]
  * reference = "start-afib"
* mitigation[0]
  * action
    * coding[0]
      * system = "local"
      * code = #replaceaspirin
      * display = "Drug conflict"
    * text = "Replace aspirin with warfarin or DOAC due to conflict with CKD"
  * note
    * text = "ckd-aspirin"

Instance: RemoveBBImpl
InstanceOf: RequestOrchestration
* id = "removebb"
* intent = #directive
* status = #active

Instance: ReplacePCBImpl
InstanceOf: RequestOrchestration
* id = "replacepcb"
* intent = #directive
* status = #active
* action[0]
  * id = "replace-pcb"
  * title = "Prescribe SCB"
  * cardinalityBehavior = #single
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

Instance: ReplaceAspirinImpl
InstanceOf: RequestOrchestration
* id = "replaceaspirin"
* intent = #directive
* status = #active
* action[0]
  * id = "replace-aspirin"
  * title = "Prescribe Warfarin or DOAC"
  * cardinalityBehavior = #single
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
