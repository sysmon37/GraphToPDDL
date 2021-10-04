(define (problem simpleCPG16-problem)
    (:domain simpleCPG16-domain)

(:objects d1 d2 - disease
          A0 A1 A2 A3 A7 A4 T1 T2 T3 G1 G2 newAction newAction0 - node
          rev1 rev2 - revID
)

;;We are "unsharing" A3 and so renaming A3D1 to A3 and A3D2 to A7.

(:init (= (decisionBranchMin d1 T1 A0) 0)
       (= (decisionBranchMax d1 T1 A0) 3)
       (= (decisionBranchMin d1 T1 A1) 4)
       (= (decisionBranchMax d1 T1 A1) 6)
       (= (decisionBranchMin d1 T1 A2) 7)
       (= (decisionBranchMax d1 T1 A2) 10)

       (= (decisionBranchMin d1 T2 G1) 0)
       (= (decisionBranchMax d1 T2 G1) 4)
       (= (decisionBranchMin d1 T2 A3) 5)
       (= (decisionBranchMax d1 T2 A3) 10)

       (= (decisionBranchMin d2 T3 G2) 5)
       (= (decisionBranchMax d2 T3 G2) 10)
       (= (decisionBranchMin d2 T3 A7) 0)
       (= (decisionBranchMax d2 T3 A7) 4)
       (= (decisionBranchMin d2 T3 newAction) 0)
       (= (decisionBranchMax d2 T3 newAction) 4)
       (= (decisionBranchMin d2 T3 newAction0) 0)
       (= (decisionBranchMax d2 T3 newAction0) 4)

       ;;patient value  as a property of the edge
       ;;V1 = 1
       (= (patientValue d1 T1 A0) 1)
       (= (patientValue d1 T1 A1) 1)
       (= (patientValue d1 T1 A2) 1)

       ;;V2 = 3
       (= (patientValue d1 T2 G1) 3)
       (= (patientValue d1 T2 A3) 3)

       ;;V3 = 2
       (= (patientValue d2 T3 G2) 2)
       (= (patientValue d2 T3 A7) 2)
       (= (patientValue d2 T3 newAction) 2)
       (= (patientValue d2 T3 newAction0) 2)

       (noPreviousDecision d1)
       ;;(noPreviousAction d1)
       ;;(noPreviousDecision d2)
       (noPreviousAction d2)

       (initialNode d1 T1)
       (initialNode d2 A4)
       (goalNode d1 G1)
       (goalNode d2 G2)

       (predecessorNode T1 A0)
       (predecessorNode T1 A1)
       (predecessorNode T1 A2)
       (predecessorNode A0 T2)
       (predecessorNode A1 T2)
       (predecessorNode A2 T2)
       (predecessorNode T2 G1)
       (predecessorNode T2 A3)
       (predecessorNode A3 G1)

       (predecessorNode A4 T3)
       (predecessorNode T3 G2)
       (predecessorNode T3 A7)
       (predecessorNode A7 G2)
       (predecessorNode T3 newAction)
       (predecessorNode newAction G2)
       (predecessorNode T3 newAction0)
       (predecessorNode newAction0 G2)

       (decisionNode T1)
       (decisionNode T2)
       (decisionNode T3)

       (actionNode A0)
       (actionNode A1)
       (actionNode A2)
       (actionNode A3)
       (actionNode A7)
       (actionNode A4)
       (actionNode newAction)
       (actionNode newAction0)

       (originalAction A0)
       (originalAction A1)
       (originalAction A2)
       (originalAction A3)
       (originalAction A7)
       (originalAction A4)

       (revisionAction newAction)
       (revisionAction newAction0)

       ;;Revision (A2+A7, newAction): rev1

       (= (revisionFlag A0 rev1) 0)
       (= (revisionFlag A1 rev1) 0)
       (= (revisionFlag A2 rev1) 1)
       (= (revisionFlag A3 rev1) 0)
       (= (revisionFlag A7 rev1) 1)
       (= (revisionFlag A4 rev1) 0)
       (= (revisionFlag T1 rev1) 0)
       (= (revisionFlag T2 rev1) 0)
       (= (revisionFlag T3 rev1) 0)
       (= (revisionFlag G1 rev1) 0)
       (= (revisionFlag G2 rev1) 0)
       (= (revisionFlag newAction rev1) 0)
       (= (revisionFlag newAction0 rev1) 1)

       (= (revisionSequenceNumNodes rev1) 2)
       (= (numNodesToReplace rev1) 1)
       (= (revisionCount rev1) 0)
       (= (revisionIDPass d1 rev1) 0)
       (= (revisionIDPass d2 rev1) 0)

       ;;Revision (A0+A7, newAction0): rev2

       (= (revisionFlag A0 rev2) 1)
       (= (revisionFlag A1 rev2) 0)
       (= (revisionFlag A2 rev2) 0)
       (= (revisionFlag A3 rev2) 0)
       (= (revisionFlag A7 rev2) 1)
       (= (revisionFlag A4 rev2) 0)
       (= (revisionFlag T1 rev2) 0)
       (= (revisionFlag T2 rev2) 0)
       (= (revisionFlag T3 rev2) 0)
       (= (revisionFlag G1 rev2) 0)
       (= (revisionFlag G2 rev2) 0)
       (= (revisionFlag newAction rev2) 1)
       (= (revisionFlag newAction0 rev2) 0)

       (= (revisionSequenceNumNodes rev2) 2)
       (= (numNodesToReplace rev2) 1)
       (= (revisionCount rev2) 0)
       (= (revisionIDPass d1 rev2) 0)
       (= (revisionIDPass d2 rev2) 0)

       (= (allRevisionsPass d1) 0)
       (= (allRevisionsPass d2) 0)
       (= (numRevisionIDs d1) 2)
       (= (numRevisionIDs d2) 2)

       (anyRevisionOps d1)
       (anyRevisionOps d2)

       (= (tentativeGoalCount) 0)
       (= (numGoals) 2)

       (= (nodeCost A0) 10)
       (= (nodeCost A1) 10)
       (= (nodeCost A2) 10)
       (= (nodeCost A3) 10)
       (= (nodeCost A7) 10)
       (= (nodeCost A4) 10)
       (= (nodeCost T1) 0)
       (= (nodeCost T2) 0)
       (= (nodeCost T3) 0)
       (= (nodeCost G1) 0)
       (= (nodeCost G2) 0)
       (= (nodeCost newAction) 100)
       (= (nodeCost newAction0) 100)

       (= (total-cost) 0)
)

(:goal (and (treatmentPlanReady d1 G1)
            (treatmentPlanReady d2 G2)
       )
)

(:metric minimize (total-cost))

)

;problem instance consisting of objects, initial and goal requirements.
