(define (problem simpleCPG22ACHrev-problem)
    (:domain simpleCPG22-domain)

(:objects d d2 d3 - disease
          SPCIRCUM AFIBTYPE RESOLVE HIGHRECUR AFIBRECUR_TACHYCARDIA IMPROVE WARFDOAC BBCBBD4WKS BBCBBDLIFE CARDIO PILL DFA P9 P10 PDFA_END PBBCBBDLIFE_END newSCB newNoBB G - node
          eGFR HEMOGLOBIN FERRITIN METABOLICABNORMALITY ESALIFE ORALIRON8WKS P5 P6 PACEINHIBLIFE PACEINHIBLIFE_END PASPIRINLIFE PANTICOAGLIFE_END PLIFESTYLE PLIFESTYLE_END P7 P8 PPHOSPHATELIFE PPHOSPHATELIFE_END newPDOACLIFE G2 - node
          AGE55 BPCONTROL2 BPCONTROL3 LIFESTYLE ACE12WKS CCB12WKS P1 P2 PACE12WKS PACE12WKS_END PDIURET12WKS PDI12WKS_END P3 P4 PACELIFE PACELIFE_END PDIURETLIFE PDIURETLIFE_END PCCBLIFE PCCBLIFE_END PSPECIALIST1HR PSPEC_END G3 - node
          rev1 rev2 rev3 - revID
)

;;rev4

;;CKD
(:init (= (decisionBranchMin d2 eGFR HEMOGLOBIN) 0)
       (= (decisionBranchMax d2 eGFR HEMOGLOBIN) 59)
       (= (decisionBranchMin d2 eGFR P5) 60)
       (= (decisionBranchMax d2 eGFR P5) 1000)

       (= (decisionBranchMin d2 HEMOGLOBIN ESALIFE) 0)
       (= (decisionBranchMax d2 HEMOGLOBIN ESALIFE) 99)
       (= (decisionBranchMin d2 HEMOGLOBIN FERRITIN) 100)
       (= (decisionBranchMax d2 HEMOGLOBIN FERRITIN) 1000)

       (= (decisionBranchMin d2 FERRITIN ORALIRON8WKS) 0)
       (= (decisionBranchMax d2 FERRITIN ORALIRON8WKS) 99)
       (= (decisionBranchMin d2 FERRITIN METABOLICABNORMALITY) 100)
       (= (decisionBranchMax d2 FERRITIN METABOLICABNORMALITY) 1000)

       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d2 METABOLICABNORMALITY P5) 0)
       (= (decisionBranchMax d2 METABOLICABNORMALITY P5) 5)
       (= (decisionBranchMin d2 METABOLICABNORMALITY P7) 6)
       (= (decisionBranchMax d2 METABOLICABNORMALITY P7) 10)


       ;;HTN
       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d3 AGE55 CCB12WKS) 0)
       (= (decisionBranchMax d3 AGE55 CCB12WKS) 5)
       (= (decisionBranchMin d3 AGE55 ACE12WKS) 6)
       (= (decisionBranchMax d3 AGE55 ACE12WKS) 10)

       (= (decisionBranchMin d3 BPCONTROL2 P1) 0)
       (= (decisionBranchMax d3 BPCONTROL2 P1) 5)
       (= (decisionBranchMin d3 BPCONTROL2 G3) 6)
       (= (decisionBranchMax d3 BPCONTROL2 G3) 10)

       (= (decisionBranchMin d3 BPCONTROL3 P3) 0)
       (= (decisionBranchMax d3 BPCONTROL3 P3) 5)
       (= (decisionBranchMin d3 BPCONTROL3 G3) 6)
       (= (decisionBranchMax d3 BPCONTROL3 G3) 10)


       ;;AFib
       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d SPCIRCUM BBCBBD4WKS) 0)
       (= (decisionBranchMax d SPCIRCUM BBCBBD4WKS) 5)
       (= (decisionBranchMin d SPCIRCUM AFIBTYPE) 6)
       (= (decisionBranchMax d SPCIRCUM AFIBTYPE) 10)

       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d AFIBTYPE HIGHRECUR) 0)
       (= (decisionBranchMax d AFIBTYPE HIGHRECUR) 5)
       (= (decisionBranchMin d AFIBTYPE CARDIO) 6)
       (= (decisionBranchMax d AFIBTYPE CARDIO) 10)

       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d RESOLVE AFIBTYPE) 0)
       (= (decisionBranchMax d RESOLVE AFIBTYPE) 5)
       (= (decisionBranchMin d RESOLVE BBCBBDLIFE) 6)
       (= (decisionBranchMax d RESOLVE BBCBBDLIFE) 10)
       (= (decisionBranchMin d RESOLVE newNoBB) 6)
       (= (decisionBranchMax d RESOLVE newNoBB) 10)

       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d HIGHRECUR PILL) 0)
       (= (decisionBranchMax d HIGHRECUR PILL) 5)
       (= (decisionBranchMin d HIGHRECUR DFA) 6)
       (= (decisionBranchMax d HIGHRECUR DFA) 10)
       (= (decisionBranchMin d HIGHRECUR newSCB) 6)
       (= (decisionBranchMax d HIGHRECUR newSCB) 10)

       ;;No [0-5] / Yes [6-10]
       (= (decisionBranchMin d IMPROVE BBCBBDLIFE) 0)
       (= (decisionBranchMax d IMPROVE BBCBBDLIFE) 5)
       (= (decisionBranchMin d IMPROVE AFIBRECUR_TACHYCARDIA) 6)
       (= (decisionBranchMax d IMPROVE AFIBRECUR_TACHYCARDIA) 10)
       (= (decisionBranchMin d IMPROVE newNoBB) 0)
       (= (decisionBranchMax d IMPROVE newNoBB) 5)

       ;;No AFib Recur and No Tachycardia: [0-2]
       ;;Yes AFib Recur and No Tachycardia: [3-5]
       ;;No AFib Recur and Yes Tachycardia: [6-8]
       ;;Yes AFib Recur and Yes Tachycardia: [9-10]
       (= (decisionBranchMin d AFIBRECUR_TACHYCARDIA G) 0)
       (= (decisionBranchMax d AFIBRECUR_TACHYCARDIA G) 2)
       (= (decisionBranchMin d AFIBRECUR_TACHYCARDIA DFA) 3)
       (= (decisionBranchMax d AFIBRECUR_TACHYCARDIA DFA) 5)
       (= (decisionBranchMin d AFIBRECUR_TACHYCARDIA BBCBBDLIFE) 6)
       (= (decisionBranchMax d AFIBRECUR_TACHYCARDIA BBCBBDLIFE) 8)
       (= (decisionBranchMin d AFIBRECUR_TACHYCARDIA P9) 9)
       (= (decisionBranchMax d AFIBRECUR_TACHYCARDIA P9) 10)
       (= (decisionBranchMin d AFIBRECUR_TACHYCARDIA newSCB) 3)
       (= (decisionBranchMax d AFIBRECUR_TACHYCARDIA newSCB) 5)
       (= (decisionBranchMin d AFIBRECUR_TACHYCARDIA newNoBB) 6)
       (= (decisionBranchMax d AFIBRECUR_TACHYCARDIA newNoBB) 8)


       ;;patient value  as a property of the edge
       ;;HTN
       ;;V1 = 0
       (= (patientValue d3 AGE55 CCB12WKS) 0)
       (= (patientValue d3 AGE55 ACE12WKS) 0)

       ;;V2 = 0
       (= (patientValue d3 BPCONTROL2 P1) 0)
       (= (patientValue d3 BPCONTROL2 G3) 0)

       ;;V3 = 0
       (= (patientValue d3 BPCONTROL3 P3) 0)
       (= (patientValue d3 BPCONTROL3 G3) 0)


       ;;patient value  as a property of the edge
       ;;CKD
       ;;V1 = 25
       (= (patientValue d2 eGFR HEMOGLOBIN) 25)
       (= (patientValue d2 eGFR P5) 25)

       ;;V2 = 95
       (= (patientValue d2 HEMOGLOBIN ESALIFE) 95)
       (= (patientValue d2 HEMOGLOBIN FERRITIN) 95)

       ;;V3 = 110
       (= (patientValue d2 FERRITIN ORALIRON8WKS) 110)
       (= (patientValue d2 FERRITIN METABOLICABNORMALITY) 110)

       ;;V4 = 0
       (= (patientValue d2 METABOLICABNORMALITY P5) 0)
       (= (patientValue d2 METABOLICABNORMALITY P7) 0)


       ;;patient value  as a property of the edge
       ;;AFib
       ;;V1 = 7
       (= (patientValue d SPCIRCUM BBCBBD4WKS) 7)
       (= (patientValue d SPCIRCUM AFIBTYPE) 7)

       ;;V2 = 7
       (= (patientValue d AFIBTYPE HIGHRECUR) 7)
       (= (patientValue d AFIBTYPE CARDIO) 7)

       ;;V3 = 7
       (= (patientValue d RESOLVE AFIBTYPE) 7)
       (= (patientValue d RESOLVE BBCBBDLIFE) 7)
       (= (patientValue d RESOLVE newNoBB) 7)

       ;;V4 = 7
       (= (patientValue d HIGHRECUR PILL) 7)
       (= (patientValue d HIGHRECUR DFA) 7)
       (= (patientValue d HIGHRECUR newSCB) 7)

       ;;V5 = 7
       (= (patientValue d IMPROVE BBCBBDLIFE) 7)
       (= (patientValue d IMPROVE AFIBRECUR_TACHYCARDIA) 7)
       (= (patientValue d IMPROVE newNoBB) 7)

       ;;V6 = 9
       (= (patientValue d AFIBRECUR_TACHYCARDIA G) 9)
       (= (patientValue d AFIBRECUR_TACHYCARDIA DFA) 9)
       (= (patientValue d AFIBRECUR_TACHYCARDIA BBCBBDLIFE) 9)
       (= (patientValue d AFIBRECUR_TACHYCARDIA P9) 9)
       (= (patientValue d AFIBRECUR_TACHYCARDIA newSCB) 9)
       (= (patientValue d AFIBRECUR_TACHYCARDIA newNoBB) 9)


       (noPreviousDecision d3)
       (noPreviousAction d3)

       (initialNode d3 LIFESTYLE)
       (goalNode d3 G3)

       (noPreviousDecision d2)
       ;;(noPreviousAction d2)

       (initialNode d2 eGFR)
       (goalNode d2 G2)

       (noPreviousDecision d)
       (noPreviousAction d)

       (initialNode d WARFDOAC)
       (goalNode d G)

       (= (tentativeGoalCount) 0)
       (= (numGoals) 3)


       ;;
       ;;HTN
       ;;
       (predecessorNode LIFESTYLE AGE55)
       (predecessorNode AGE55 ACE12WKS)
       (predecessorNode AGE55 CCB12WKS)
       (predecessorNode ACE12WKS BPCONTROL2)
       (predecessorNode CCB12WKS BPCONTROL2)
       (predecessorNode BPCONTROL2 G3)

       (predecessorNode BPCONTROL2 P1)
       (predecessorNode P1 PACE12WKS)
       (predecessorNode PACE12WKS PACE12WKS_END)
       (predecessorNode P1 PDIURET12WKS)
       (predecessorNode PDIURET12WKS PDI12WKS_END)
       (predecessorNode PACE12WKS_END P2)
       (predecessorNode PDI12WKS_END P2)
       (predecessorNode P2 BPCONTROL3)

       (predecessorNode BPCONTROL3 G3)
       (predecessorNode BPCONTROL3 P3)
       (predecessorNode P3 PACELIFE)
       (predecessorNode PACELIFE PACELIFE_END)
       (predecessorNode P3 PDIURETLIFE)
       (predecessorNode PDIURETLIFE PDIURETLIFE_END)
       (predecessorNode P3 PCCBLIFE)
       (predecessorNode PCCBLIFE PCCBLIFE_END)
       (predecessorNode P3 PSPECIALIST1HR)
       (predecessorNode PSPECIALIST1HR PSPEC_END)
       (predecessorNode PACELIFE_END P4)
       (predecessorNode PDIURETLIFE_END P4)
       (predecessorNode PCCBLIFE_END P4)
       (predecessorNode PSPEC_END P4)
       (predecessorNode P4 G3)

       (decisionNode AGE55)
       (decisionNode BPCONTROL2)
       (decisionNode BPCONTROL3)

       (actionNode LIFESTYLE)
       (actionNode ACE12WKS)
       (actionNode CCB12WKS)

       (parallelStartNode P1)
       (parallelEndNode P2)
       (parallelActionNode PACE12WKS)
       (parallelActionNode PACE12WKS_END)
       (parallelActionNode PDIURET12WKS)
       (parallelActionNode PDI12WKS_END)
       (untraversedParallelNode PACE12WKS)
       (untraversedParallelNode PACE12WKS_END)
       (untraversedParallelNode PDIURET12WKS)
       (untraversedParallelNode PDI12WKS_END)

       (parallelStartNode P3)
       (parallelEndNode P4)
       (parallelActionNode PACELIFE)
       (parallelActionNode PACELIFE_END)
       (parallelActionNode PDIURETLIFE)
       (parallelActionNode PDIURETLIFE_END)
       (parallelActionNode PCCBLIFE)
       (parallelActionNode PCCBLIFE_END)
       (parallelActionNode PSPECIALIST1HR)
       (parallelActionNode PSPEC_END)
       (untraversedParallelNode PACELIFE)
       (untraversedParallelNode PACELIFE_END)
       (untraversedParallelNode PDIURETLIFE)
       (untraversedParallelNode PDIURETLIFE_END)
       (untraversedParallelNode PCCBLIFE)
       (untraversedParallelNode PCCBLIFE_END)
       (untraversedParallelNode PSPECIALIST1HR)
       (untraversedParallelNode PSPEC_END)

       (sameParallelBlockNodes P1 P2)
       (sameParallelBlockNodes P3 P4)

       (= (parallelPathCount P2 d3) 0)
       (= (numParallelPaths P2 d3) 2)

       (= (parallelPathCount P4 d3) 0)
       (= (numParallelPaths P4 d3) 4)


       ;;;;
       (= (parallelPathCount P2 d2) 0)
       (= (numParallelPaths P2 d2) 0)

       (= (parallelPathCount P4 d2) 0)
       (= (numParallelPaths P4 d2) 0)

       (= (parallelPathCount P2 d) 0)
       (= (numParallelPaths P2 d) 0)

       (= (parallelPathCount P4 d) 0)
       (= (numParallelPaths P4 d) 0)


       (= (allRevisionsPass d3) 0)
       (= (numRevisionIDs d3) 0)
       (noRevisionOps d3)


       ;;
       ;;CKD
       ;;
       (predecessorNode eGFR HEMOGLOBIN)
       (predecessorNode eGFR P5)
       (predecessorNode HEMOGLOBIN ESALIFE)
       (predecessorNode HEMOGLOBIN FERRITIN)
       (predecessorNode ESALIFE FERRITIN)
       (predecessorNode FERRITIN ORALIRON8WKS)
       (predecessorNode FERRITIN METABOLICABNORMALITY)
       (predecessorNode ORALIRON8WKS METABOLICABNORMALITY)
       (predecessorNode METABOLICABNORMALITY P7)
       (predecessorNode METABOLICABNORMALITY P5)

       (predecessorNode P5 PACEINHIBLIFE)
       (predecessorNode PACEINHIBLIFE PACEINHIBLIFE_END)
       (predecessorNode PACEINHIBLIFE_END P6)
       (predecessorNode P5 PASPIRINLIFE)
       (predecessorNode PASPIRINLIFE PANTICOAGLIFE_END)
       (predecessorNode PANTICOAGLIFE_END P6)
       (predecessorNode P5 PLIFESTYLE)
       (predecessorNode PLIFESTYLE PLIFESTYLE_END)
       (predecessorNode PLIFESTYLE_END P6)
       (predecessorNode P6 G2)

       (predecessorNode P5 newPDOACLIFE)
       (predecessorNode newPDOACLIFE PANTICOAGLIFE_END)

       (predecessorNode P7 PPHOSPHATELIFE)
       (predecessorNode PPHOSPHATELIFE PPHOSPHATELIFE_END)
       (predecessorNode PPHOSPHATELIFE_END P8)
       (predecessorNode P7 PACEINHIBLIFE)
       (predecessorNode PACEINHIBLIFE PACEINHIBLIFE_END)
       (predecessorNode PACEINHIBLIFE_END P8)
       (predecessorNode P7 PASPIRINLIFE)
       (predecessorNode PASPIRINLIFE PANTICOAGLIFE_END)
       (predecessorNode PANTICOAGLIFE_END P8)
       (predecessorNode P7 PLIFESTYLE)
       (predecessorNode PLIFESTYLE PLIFESTYLE_END)
       (predecessorNode PLIFESTYLE_END P8)
       (predecessorNode P8 G2)

       (predecessorNode P7 newPDOACLIFE)
       (predecessorNode newPDOACLIFE PANTICOAGLIFE_END)

       (decisionNode eGFR)
       (decisionNode HEMOGLOBIN)
       (decisionNode FERRITIN)
       (decisionNode METABOLICABNORMALITY)

       (actionNode ESALIFE)
       (actionNode ORALIRON8WKS)

       (originalAction ESALIFE)
       (originalAction ORALIRON8WKS)

       (parallelStartNode P5)
       (parallelEndNode P6)
       (parallelActionNode PACEINHIBLIFE)
       (parallelActionNode PACEINHIBLIFE_END)
       (parallelActionNode PASPIRINLIFE)
       (parallelActionNode PANTICOAGLIFE_END)
       (parallelActionNode PLIFESTYLE)
       (parallelActionNode PLIFESTYLE_END)
       (parallelActionNode newPDOACLIFE)

       (untraversedParallelNode P5)
       (untraversedParallelNode P6)
       (untraversedParallelNode PACEINHIBLIFE)
       (untraversedParallelNode PACEINHIBLIFE_END)
       (untraversedParallelNode PASPIRINLIFE)
       (untraversedParallelNode PANTICOAGLIFE_END)
       (untraversedParallelNode PLIFESTYLE)
       (untraversedParallelNode PLIFESTYLE_END)
       (untraversedParallelNode newPDOACLIFE)

       (parallelStartNode P7)
       (parallelEndNode P8)
       (parallelActionNode PPHOSPHATELIFE)
       (parallelActionNode PPHOSPHATELIFE_END)

       (untraversedParallelNode P7)
       (untraversedParallelNode P8)
       (untraversedParallelNode PPHOSPHATELIFE)
       (untraversedParallelNode PPHOSPHATELIFE_END)

       (sameParallelBlockNodes P5 P6)
       (sameParallelBlockNodes P7 P8)

       (= (parallelPathCount P6 d2) 0)
       (= (numParallelPaths P6 d2) 3)

       (= (parallelPathCount P8 d2) 0)
       (= (numParallelPaths P8 d2) 4)


       ;;;;
       (= (parallelPathCount P6 d3) 0)
       (= (numParallelPaths P6 d3) 0)

       (= (parallelPathCount P8 d3) 0)
       (= (numParallelPaths P8 d3) 0)

       (= (parallelPathCount P6 d) 0)
       (= (numParallelPaths P6 d) 0)

       (= (parallelPathCount P8 d) 0)
       (= (numParallelPaths P8 d) 0)


       ;;Revision rev2

       (revisionAction newPDOACLIFE)

       (= (revisionSequenceNumNodes rev2) 1)
       (= (numNodesToReplace rev2) 1)
       (= (revisionCount rev2) 0)
       (= (revisionIDPass d2 rev2) 0)

       (= (allRevisionsPass d2) 0)
       (= (numRevisionIDs d2) 1)
       ;;(noRevisionOps d2)
       (anyRevisionOps d2)

       (= (revisionFlag eGFR rev2) 0)
       (= (revisionFlag HEMOGLOBIN rev2) 0)
       (= (revisionFlag FERRITIN rev2) 0)
       (= (revisionFlag METABOLICABNORMALITY rev2) 0)
       (= (revisionFlag ESALIFE rev2) 0)
       (= (revisionFlag ORALIRON8WKS rev2) 0)
       (= (revisionFlag P5 rev2) 0)
       (= (revisionFlag P6 rev2) 0)
       (= (revisionFlag PACEINHIBLIFE rev2) 0)
       (= (revisionFlag PACEINHIBLIFE_END rev2) 0)
       (= (revisionFlag PASPIRINLIFE rev2) 1)
       (= (revisionFlag PANTICOAGLIFE_END rev2) 0)
       (= (revisionFlag PLIFESTYLE rev2) 0)
       (= (revisionFlag PLIFESTYLE_END rev2) 0)
       (= (revisionFlag P7 rev2) 0)
       (= (revisionFlag P8 rev2) 0)
       (= (revisionFlag PPHOSPHATELIFE rev2) 0)
       (= (revisionFlag PPHOSPHATELIFE_END rev2) 0)
       (= (revisionFlag G2 rev2) 0)
       (= (revisionFlag newPDOACLIFE rev2) 0)


       ;;
       ;;d = AFib
       ;;
       (predecessorNode WARFDOAC SPCIRCUM)
       (predecessorNode SPCIRCUM BBCBBD4WKS)
       (predecessorNode SPCIRCUM AFIBTYPE)
       (predecessorNode BBCBBD4WKS RESOLVE)
       (predecessorNode RESOLVE AFIBTYPE)
       (predecessorNode RESOLVE BBCBBDLIFE)
       (predecessorNode RESOLVE newNoBB)
       (predecessorNode BBCBBDLIFE G)
       (predecessorNode newNoBB G)
       (predecessorNode AFIBTYPE HIGHRECUR)
       (predecessorNode AFIBTYPE CARDIO)
       (predecessorNode CARDIO IMPROVE)
       (predecessorNode IMPROVE BBCBBDLIFE)
       (predecessorNode IMPROVE newNoBB)
       (predecessorNode IMPROVE AFIBRECUR_TACHYCARDIA)
       (predecessorNode AFIBRECUR_TACHYCARDIA DFA)
       (predecessorNode AFIBRECUR_TACHYCARDIA newSCB)
       (predecessorNode AFIBRECUR_TACHYCARDIA BBCBBDLIFE)
       (predecessorNode AFIBRECUR_TACHYCARDIA newNoBB)
       (predecessorNode AFIBRECUR_TACHYCARDIA P9)
       (predecessorNode AFIBRECUR_TACHYCARDIA G)
       (predecessorNode HIGHRECUR PILL)
       (predecessorNode HIGHRECUR DFA)
       (predecessorNode HIGHRECUR newSCB)
       (predecessorNode PILL G)
       (predecessorNode DFA G)
       (predecessorNode newSCB G)

       (predecessorNode P9 DFA)
       (predecessorNode DFA PDFA_END)
       (predecessorNode PDFA_END P10)
       (predecessorNode P9 BBCBBDLIFE)
       (predecessorNode BBCBBDLIFE PBBCBBDLIFE_END)
       (predecessorNode PBBCBBDLIFE_END P10)
       (predecessorNode P10 G)

       (predecessorNode P9 newSCB)
       (predecessorNode newSCB PDFA_END)
       (predecessorNode P9 newNoBB)
       (predecessorNode newNoBB PBBCBBDLIFE_END)


       (decisionNode SPCIRCUM)
       (decisionNode AFIBTYPE)
       (decisionNode RESOLVE)
       (decisionNode HIGHRECUR)
       (decisionNode AFIBRECUR_TACHYCARDIA)
       (decisionNode IMPROVE)

       (actionNode WARFDOAC)
       (actionNode BBCBBD4WKS)
       (actionNode BBCBBDLIFE)
       (actionNode CARDIO)
       (actionNode PILL)
       (actionNode DFA)
       (actionNode newSCB)
       (actionNode newNoBB)

       (originalAction WARFDOAC)
       (originalAction BBCBBD4WKS)
       (originalAction BBCBBDLIFE)
       (originalAction CARDIO)
       (originalAction PILL)
       (originalAction DFA)

       (parallelStartNode P9)
       (parallelEndNode P10)
       (parallelActionNode DFA)
       (parallelActionNode PDFA_END)
       (parallelActionNode BBCBBDLIFE)
       (parallelActionNode PBBCBBDLIFE_END)
       (parallelActionNode newSCB)
       (parallelActionNode newNoBB)

       (untraversedParallelNode P9)
       (untraversedParallelNode P10)
       (untraversedParallelNode DFA)
       (untraversedParallelNode PDFA_END)
       (untraversedParallelNode BBCBBDLIFE)
       (untraversedParallelNode PBBCBBDLIFE_END)
       (untraversedParallelNode newSCB)
       (untraversedParallelNode newNoBB)

       (sameParallelBlockNodes P9 P10)
       (= (parallelPathCount P10 d) 0)
       (= (numParallelPaths P10 d) 2)

       ;;;;
       (= (parallelPathCount P10 d2) 0)
       (= (numParallelPaths P10 d2) 0)

       (= (parallelPathCount P10 d3) 0)
       (= (numParallelPaths P10 d3) 0)


       (revisionAction newSCB)
       (revisionAction newNoBB)

       ;;Revision rev1

       (= (revisionFlag SPCIRCUM rev1) 0)
       (= (revisionFlag AFIBTYPE rev1) 0)
       (= (revisionFlag RESOLVE rev1) 0)
       (= (revisionFlag HIGHRECUR rev1) 0)
       (= (revisionFlag AFIBRECUR_TACHYCARDIA rev1) 0)
       (= (revisionFlag IMPROVE rev1) 0)
       (= (revisionFlag WARFDOAC rev1) 0)
       (= (revisionFlag BBCBBD4WKS rev1) 0)
       (= (revisionFlag BBCBBDLIFE rev1) 0)
       (= (revisionFlag CARDIO rev1) 0)
       (= (revisionFlag PILL rev1) 0)
       (= (revisionFlag DFA rev1) 1)
       (= (revisionFlag G rev1) 0)
       (= (revisionFlag newSCB rev1) 0)

       (= (revisionFlag P9 rev1) 0)
       (= (revisionFlag P10 rev1) 0)
       (= (revisionFlag PDFA_END rev1) 0)
       (= (revisionFlag PBBCBBDLIFE_END rev1) 0)

       (= (revisionSequenceNumNodes rev1) 1)
       (= (numNodesToReplace rev1) 1)
       (= (revisionCount rev1) 0)
       (= (revisionIDPass d rev1) 0)

       ;;Revision rev3

       (= (revisionFlag SPCIRCUM rev3) 0)
       (= (revisionFlag AFIBTYPE rev3) 0)
       (= (revisionFlag RESOLVE rev3) 0)
       (= (revisionFlag HIGHRECUR rev3) 0)
       (= (revisionFlag AFIBRECUR_TACHYCARDIA rev3) 0)
       (= (revisionFlag IMPROVE rev3) 0)
       (= (revisionFlag WARFDOAC rev3) 0)
       (= (revisionFlag BBCBBD4WKS rev3) 0)
       (= (revisionFlag BBCBBDLIFE rev3) 1)
       (= (revisionFlag CARDIO rev3) 0)
       (= (revisionFlag PILL rev3) 0)
       (= (revisionFlag DFA rev3) 0)
       (= (revisionFlag G rev3) 0)
       (= (revisionFlag newSCB rev3) 0)
       (= (revisionFlag newNoBB rev3) 0)

       (= (revisionFlag P9 rev3) 0)
       (= (revisionFlag P10 rev3) 0)
       (= (revisionFlag PDFA_END rev3) 0)
       (= (revisionFlag PBBCBBDLIFE_END rev3) 0)

       (= (revisionSequenceNumNodes rev3) 1)
       (= (numNodesToReplace rev3) 1)
       (= (revisionCount rev3) 0)
       (= (revisionIDPass d rev3) 0)

       (= (allRevisionsPass d) 0)
       (= (numRevisionIDs d) 2)
       ;;(noRevisionOps d)
       (anyRevisionOps d)


       ;;Different cost/metric functions.
       (= (total-cost) 0)
       (= (total-burden) 0)
       (= (total-nonadherence) 0)

       ;;Cost consideration (price of treatment)
       ;;HTN
       (= (nodeCost AGE55) 0)
       (= (nodeCost BPCONTROL2) 0)
       (= (nodeCost BPCONTROL3) 0)
       (= (nodeCost LIFESTYLE) 10)
       (= (nodeCost ACE12WKS) 10)
       (= (nodeCost CCB12WKS) 10)
       (= (nodeCost G3) 0)

       (= (nodeCost P1) 0)
       (= (nodeCost P2) 0)
       (= (nodeCost PACE12WKS) 10)
       (= (nodeCost PACE12WKS_END) 0)
       (= (nodeCost PDIURET12WKS) 10)
       (= (nodeCost PDI12WKS_END) 0)

       (= (nodeCost P3) 0)
       (= (nodeCost P4) 0)
       (= (nodeCost PACELIFE) 10)
       (= (nodeCost PACELIFE_END) 0)
       (= (nodeCost PDIURETLIFE) 10)
       (= (nodeCost PDIURETLIFE_END) 0)
       (= (nodeCost PCCBLIFE) 10)
       (= (nodeCost PCCBLIFE_END) 0)
       (= (nodeCost PSPECIALIST1HR) 10)
       (= (nodeCost PSPEC_END) 0)


       ;;CKD
       (= (nodeCost eGFR) 0)
       (= (nodeCost HEMOGLOBIN) 0)
       (= (nodeCost FERRITIN) 0)
       (= (nodeCost METABOLICABNORMALITY) 0)
       (= (nodeCost ESALIFE) 10)
       (= (nodeCost ORALIRON8WKS) 10)
       (= (nodeCost G2) 0)

       (= (nodeCost P5) 0)
       (= (nodeCost P6) 0)
       (= (nodeCost PACEINHIBLIFE) 10)
       (= (nodeCost PACEINHIBLIFE_END) 0)
       (= (nodeCost PASPIRINLIFE) 10)
       (= (nodeCost PANTICOAGLIFE_END) 0)
       (= (nodeCost PLIFESTYLE) 10)
       (= (nodeCost PLIFESTYLE_END) 0)
       (= (nodeCost newPDOACLIFE) 20)

       (= (nodeCost P7) 0)
       (= (nodeCost P8) 0)
       (= (nodeCost PPHOSPHATELIFE) 10)
       (= (nodeCost PPHOSPHATELIFE_END) 0)


       ;;AFib
       (= (nodeCost SPCIRCUM) 0)
       (= (nodeCost RESOLVE) 0)
       (= (nodeCost AFIBTYPE) 0)
       (= (nodeCost HIGHRECUR) 0)
       (= (nodeCost AFIBRECUR_TACHYCARDIA) 0)
       (= (nodeCost IMPROVE) 0)
       (= (nodeCost WARFDOAC) 10)
       (= (nodeCost BBCBBD4WKS) 10)
       (= (nodeCost BBCBBDLIFE) 10)
       (= (nodeCost CARDIO) 10)
       (= (nodeCost PILL) 10)
       (= (nodeCost DFA) 10)
       (= (nodeCost newSCB) 20)
       (= (nodeCost newNoBB) 20)
       (= (nodeCost G) 0)

       (= (nodeCost P9) 0)
       (= (nodeCost P10) 0)
       (= (nodeCost PDFA_END) 0)
       (= (nodeCost PBBCBBDLIFE_END) 0)


       ;;Burden consideration (want to minimize burden)
       ;;HTN
       (= (nodeBurden AGE55) 0)
       (= (nodeBurden BPCONTROL2) 0)
       (= (nodeBurden BPCONTROL3) 0)
       (= (nodeBurden LIFESTYLE) 0)
       (= (nodeBurden ACE12WKS) 0)
       (= (nodeBurden CCB12WKS) 0)
       (= (nodeBurden G3) 0)

       (= (nodeBurden P1) 0)
       (= (nodeBurden P2) 0)
       (= (nodeBurden PACE12WKS) 10)
       (= (nodeBurden PACE12WKS_END) 0)
       (= (nodeBurden PDIURET12WKS) 10)
       (= (nodeBurden PDI12WKS_END) 0)

       (= (nodeBurden P3) 0)
       (= (nodeBurden P4) 0)
       (= (nodeBurden PACELIFE) 10)
       (= (nodeBurden PACELIFE_END) 0)
       (= (nodeBurden PDIURETLIFE) 10)
       (= (nodeBurden PDIURETLIFE_END) 0)
       (= (nodeBurden PCCBLIFE) 10)
       (= (nodeBurden PCCBLIFE_END) 0)
       (= (nodeBurden PSPECIALIST1HR) 10)
       (= (nodeBurden PSPEC_END) 0)


       ;;CKD
       (= (nodeBurden eGFR) 0)
       (= (nodeBurden HEMOGLOBIN) 0)
       (= (nodeBurden FERRITIN) 0)
       (= (nodeBurden METABOLICABNORMALITY) 0)
       (= (nodeBurden ESALIFE) 0)
       (= (nodeBurden ORALIRON8WKS) 0)
       (= (nodeBurden G2) 0)

       (= (nodeBurden P5) 0)
       (= (nodeBurden P6) 0)
       (= (nodeBurden PACEINHIBLIFE) 10)
       (= (nodeBurden PACEINHIBLIFE_END) 0)
       (= (nodeBurden PASPIRINLIFE) 10)
       (= (nodeBurden PANTICOAGLIFE_END) 0)
       (= (nodeBurden PLIFESTYLE) 10)
       (= (nodeBurden PLIFESTYLE_END) 0)
       (= (nodeBurden newPDOACLIFE) 20)

       (= (nodeBurden P7) 0)
       (= (nodeBurden P8) 0)
       (= (nodeBurden PPHOSPHATELIFE) 10)
       (= (nodeBurden PPHOSPHATELIFE_END) 0)


       ;;AFib
       (= (nodeBurden SPCIRCUM) 0)
       (= (nodeBurden RESOLVE) 0)
       (= (nodeBurden AFIBTYPE) 0)
       (= (nodeBurden HIGHRECUR) 0)
       (= (nodeBurden AFIBRECUR_TACHYCARDIA) 0)
       (= (nodeBurden IMPROVE) 0)
       (= (nodeBurden WARFDOAC) 0)
       (= (nodeBurden BBCBBD4WKS) 0)
       (= (nodeBurden BBCBBDLIFE) 0)
       (= (nodeBurden CARDIO) 10)
       (= (nodeBurden PILL) 10)
       (= (nodeBurden DFA) 10)
       (= (nodeBurden newSCB) 20)
       (= (nodeBurden newNoBB) 20)
       (= (nodeBurden G) 0)

       (= (nodeBurden P9) 0)
       (= (nodeBurden P10) 0)
       (= (nodeBurden PDFA_END) 0)
       (= (nodeBurden PBBCBBDLIFE_END) 0)


       ;;Non-adherence consideration (want to minimize non-adherence)
       ;;HTN
       (= (nodeNonAdherence AGE55) 0)
       (= (nodeNonAdherence BPCONTROL2) 0)
       (= (nodeNonAdherence BPCONTROL3) 0)
       (= (nodeNonAdherence LIFESTYLE) 0)
       (= (nodeNonAdherence ACE12WKS) 0)
       (= (nodeNonAdherence CCB12WKS) 0)
       (= (nodeNonAdherence G3) 0)

       (= (nodeNonAdherence P1) 0)
       (= (nodeNonAdherence P2) 0)
       (= (nodeNonAdherence PACE12WKS) 10)
       (= (nodeNonAdherence PACE12WKS_END) 0)
       (= (nodeNonAdherence PDIURET12WKS) 10)
       (= (nodeNonAdherence PDI12WKS_END) 0)

       (= (nodeNonAdherence P3) 0)
       (= (nodeNonAdherence P4) 0)
       (= (nodeNonAdherence PACELIFE) 10)
       (= (nodeNonAdherence PACELIFE_END) 0)
       (= (nodeNonAdherence PDIURETLIFE) 10)
       (= (nodeNonAdherence PDIURETLIFE_END) 0)
       (= (nodeNonAdherence PCCBLIFE) 10)
       (= (nodeNonAdherence PCCBLIFE_END) 0)
       (= (nodeNonAdherence PSPECIALIST1HR) 10)
       (= (nodeNonAdherence PSPEC_END) 0)


       ;;CKD
       (= (nodeNonAdherence eGFR) 0)
       (= (nodeNonAdherence HEMOGLOBIN) 0)
       (= (nodeNonAdherence FERRITIN) 0)
       (= (nodeNonAdherence METABOLICABNORMALITY) 0)
       (= (nodeNonAdherence ESALIFE) 0)
       (= (nodeNonAdherence ORALIRON8WKS) 0)
       (= (nodeNonAdherence G2) 0)

       (= (nodeNonAdherence P5) 0)
       (= (nodeNonAdherence P6) 0)
       (= (nodeNonAdherence PACEINHIBLIFE) 10)
       (= (nodeNonAdherence PACEINHIBLIFE_END) 0)
       (= (nodeNonAdherence PASPIRINLIFE) 10)
       (= (nodeNonAdherence PANTICOAGLIFE_END) 0)
       (= (nodeNonAdherence PLIFESTYLE) 10)
       (= (nodeNonAdherence PLIFESTYLE_END) 0)
       (= (nodeNonAdherence newPDOACLIFE) 20)

       (= (nodeNonAdherence P7) 0)
       (= (nodeNonAdherence P8) 0)
       (= (nodeNonAdherence PPHOSPHATELIFE) 10)
       (= (nodeNonAdherence PPHOSPHATELIFE_END) 0)


       ;;AFIB
       (= (nodeNonAdherence SPCIRCUM) 0)
       (= (nodeNonAdherence RESOLVE) 0)
       (= (nodeNonAdherence AFIBTYPE) 0)
       (= (nodeNonAdherence HIGHRECUR) 0)
       (= (nodeNonAdherence AFIBRECUR_TACHYCARDIA) 0)
       (= (nodeNonAdherence IMPROVE) 0)
       (= (nodeNonAdherence WARFDOAC) 0)
       (= (nodeNonAdherence BBCBBD4WKS) 0)
       (= (nodeNonAdherence BBCBBDLIFE) 0)
       (= (nodeNonAdherence CARDIO) 10)
       (= (nodeNonAdherence PILL) 10)
       (= (nodeNonAdherence DFA) 10)
       (= (nodeNonAdherence newSCB) 20)
       (= (nodeNonAdherence newNoBB) 20)
       (= (nodeNonAdherence G) 0)

       (= (nodeNonAdherence P9) 0)
       (= (nodeNonAdherence P10) 0)
       (= (nodeNonAdherence PDFA_END) 0)
       (= (nodeNonAdherence PBBCBBDLIFE_END) 0)

)

(:goal (and (treatmentPlanReady d G)
            (treatmentPlanReady d2 G2)
            (treatmentPlanReady d3 G3)
       )
)


;;Different metrics
;;
;;minimize (total-cost)
;;minimize (total-burden)
;;minimize (total-nonadherence)
;;
;;Combining the three considerations with weights: w1*cost + w2*burden + w3*nonadherence
;;Suppose w1=0.2, w2=0.6, w3=0.2
;;minimize (+ (* 0.2 total-cost) (* 0.6 total-burden) (* 0.2 total-nonadherence))

(:metric minimize (total-cost))

)
