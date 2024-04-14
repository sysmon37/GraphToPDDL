# FHIR integration - example files

This folder examples for all files used by mitplan.

Files that start with `ro-` are revision operators. The consist of RequestOrchestrations and DetectedIssues.

Files that start with `plan-definition-` are PlanDefinition resources.

Files that start with `data-` are files with patient data.

You can find the description of each file below:
* `data-ad-mdd.json` - example patient data for someone with Major Depressive Disorder and Alzheimer's disease. The basic idea is that the patient takes treatment for MDD and experiences improvement, but is unsuccessful with AD treatment.
* `data-dvt-scad.json` - example patient data for someone with Deep Vein Thrombosis and Spontaneous Coronary Artery Dissection. The patient data is in old format, unsupported by the new MitPlan version. It is supported by plain GraphToPDDL though.
* `plan-definition-alzheimer.json` - example PlanDefinition for treating an adult patient with [Alzheimer's Disease](https://www.mayoclinic.org/diseases-conditions/alzheimers-disease/symptoms-causes/syc-20350447).
* `plan-definition-dvt.json` - example PlanDefinition for treating an adult patient with [Deep Vein Thrombosis](https://www.mayoclinic.org/diseases-conditions/deep-vein-thrombosis/symptoms-causes/syc-20352557).
* `plan-definition-mdd.json` - example PlanDefinition for treating an adult with [Major Depressive Disorder](https://www.mayoclinic.org/diseases-conditions/depression/symptoms-causes/syc-20356007).
* `plan-definition-scad.json` - example PlanDefinition for treating an adult with Spontaneous [Coronary Artery Dissection](https://www.mayoclinic.org/diseases-conditions/spontaneous-coronary-artery-dissection/symptoms-causes/syc-20353711).
* `ro-ad-mdd.json` - example revision operators for resolving conficts between AD and MDD treatment. It contains two ADD operations.
* `ro-dvt-scad.json` - example revision operators for resolving conflicts between DVT and SCAD treatment. It contains one ADD operation and two REPLACE operations.
