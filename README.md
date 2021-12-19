# GraphToPDDL - MitPlan (Generation of PDDL Based on CPGs)

## Execute GraphToPDDL
*Possible Arguments*
- DOT_FILE: path of the dot file
- --ro: path of the revision operators json file
- --p: path of the patient values json file
- --p-name: name of the problem
- --d-name: name of the domain
- --no-ro : Flag not to apply the revision operators. Toggle.
- --dir : Path to the directory where to create the problem and graph view files. Default value is the current directory


````bash
py toPDDL.py DOT_FILE --ro REVISION_OPERATORS --p PATIENT_VALUES --p-name problem_name --d-name domain_name --dir dir_output_path
````

### Usage example
````bash
py toPDDL.py UseCases/Dot_files/testcase-1-rev.dot --ro UseCases/Revision_Operators/testcase-1-ro.json --p UseCases/PatientValues/patient-values-1-5.json --p-name problem1 --d-name domain1
````

## General information
Move to [GraphToPDDL - MitPlan (Generation of PDDL Based on CPGs)](src/readme.md)
