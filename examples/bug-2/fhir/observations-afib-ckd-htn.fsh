CodeSystem: ObservationCodes
* #htn-age "htn-age" "Age of the patient"
* #ckd-egfr "ckd-egfr" "eGFR levels"
* #ckd-hemoglobin "ckd-hemoglobin" "Hemoglobin levels"
* #ckd-metabolic-abnormality "ckd-metabolic-abnormality" "Metabolic abnormalities"
* #ckd-ferritin "ckd-ferritin" "Ferritin levels"
* #htn-bp-controlled-1 "htn-bp-controlled-1" "Is BP controlled?"
* #htn-bp-controlled-2 "htn-bp-controlled-2" "Is BP controlled?"
* #afib-special-circumstances "afib-special-circumstances" "Special circumstances for AFib"
* #afib-type "afib-type" "Type of AFib"
* #afib-high-burden-recurrence "afib-high-burden-recurrence" "High burden of AFib recurrence"
* #afib-symptoms-resolve "afib-symptoms-resolve" "Symptoms of AFib resolved"
* #afib-symptoms-improve "afib-symptoms-improve" "Symptoms of AFib improved"
* #afib-afib-recurs "afib-afib-recurs" "AFib recurs"
* #afib-tachycardia "afib-tachycardia" "Tachycardia"

Instance: eGFR
InstanceOf: Observation
* id = "egfr"
* status = #final
* code
  * coding = #mitplan
  * text = "eGFR levels"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #ckd-egfr
  * valueString = "eGFR less than 30."

Instance: Hemoglobin
InstanceOf: Observation
* id = "hemoglobin"
* status = #final
* code
  * coding = #mitplan
  * text = "Hemoglobin levels"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #ckd-hemoglobin
  * valueString = "Hemoglobin less than 95. Detected anemia."

Instance: MetabolicAbnormalities
InstanceOf: Observation
* id = "metabolic-abnormalities"
* status = #final
* code
  * coding = #mitplan
  * text = "Metabolic abnormalities"
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #ckd-metabolic-abnormality
  * valueString = "Patient does not have any metabolic disturbances."

Instance: Ferritin
InstanceOf: Observation
* id = "ferritin"
* status = #final
* code
  * coding = #mitplan
  * text = "Ferritin levels"
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #ckd-ferritin
  * valueString = "Ferritin levels at 110."

Instance: Age
InstanceOf: Observation
* id = "age"
* status = #final
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* code
  * coding = #mitplan
  * text = "Age"
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #htn-age
  * valueString = "Patient is 70 years old."

Instance: BPControlled1
InstanceOf: Observation
* id = "bp-controlled-1"
* status = #final
* code
  * coding = #mitplan
  * text = "Is BP controlled?"
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #htn-bp-controlled-1
  * valueString = "BP is not controlled in the first round of treatment."

Instance: BPControlled2
InstanceOf: Observation
* id = "bp-controlled-2"
* status = #final
* code
  * coding = #mitplan
  * text = "Is BP controlled?"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #htn-bp-controlled-2
  * valueString = "BP has been controlled in the second round of treatment."

Instance: BPControlled3
InstanceOf: Observation
* id = "bp-controlled-3"
* status = #final
* code
  * coding = #mitplan
  * text = "Is BP controlled?"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #htn-bp-controlled-3
  * valueString = "BP has been controlled in the second round of treatment."

Instance: SpecialCircumstances
InstanceOf: Observation
* id = "special-circumstances"
* status = #final
* code
  * coding = #mitplan
  * text = "Are there any special circumstances for AFib?"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-special-circumstances
  * valueString = "Special circumstances for AFib present."

Instance: PersistentAfib
InstanceOf: Observation
* id = "persistent-afib"
* status = #final
* code
  * coding = #mitplan
  * text = "Is AFib persistent?"
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-type
  * valueString = "AFib isn't persistent."

Instance: AfibRecurrence
InstanceOf: Observation
* id = "afib-recurrence"
* status = #final
* code
  * coding = #mitplan
  * text = "Is there a high risk of recurrence of AFib?"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-high-burden-recurrence
  * valueString = "High risk of AFib recurrence."

Instance: AfibSymptomsResolved
InstanceOf: Observation
* id = "sympotms-resolved"
* status = #final
* code
  * coding = #mitplan
  * text = "Are AFib symptoms resolved?"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-symptoms-resolve
  * valueString = "AFib symptoms have been temporarily resolved."

Instance: AfibSymptomsImproved
InstanceOf: Observation
* id = "sympotms-improved"
* status = #final
* code
  * coding = #mitplan
  * text = "Are AFib symptoms improved?"
* valueQuantity
  * value = 1
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-symptoms-improve
  * valueString = "AFib symptoms have been temporarily improved."

Instance: AfibRecurs
InstanceOf: Observation
* id = "afib-recurs"
* status = #final
* code
  * coding = #mitplan
  * text = "Does AFib recur?"
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-afib-recurs
  * valueString = "AFib did not recur."

Instance: Tachycardia
InstanceOf: Observation
* id = "tachycardia"
* status = #final
* code
  * coding = #mitplan
  * text = "Is tachycardia present?"
* valueQuantity
  * value = 0
  * unit = ""
  * system = ""
  * code = #mitplan
* component[0]
  * code
    * coding[0]
      * system = "local"
      * code = #afib-tachycardia
  * valueString = "Tachycardia is not preset."
