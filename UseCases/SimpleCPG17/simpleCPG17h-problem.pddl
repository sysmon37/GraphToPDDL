(define (problem simpleCPG17-problem)
    (:domain simpleCPG17-domain)

(:objects d1 d2 - disease
          A1 A2 A3 A7 A4 T1 T2 T3 G1 G2 newAction newAction2 - node
          rev1 - revID
)

;;We are "unsharing" A3 and so renaming A3D1 to A3 and A3D2 to A7.

(:init (= (decisionBranchMin d1 T1 A1) 0)
       (= (decisionBranchMax d1 T1 A1) 4)
       (= (decisionBranchMin d1 T1 A2) 5)
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
       (= (decisionBranchMin d2 T3 newAction2) 0)
       (= (decisionBranchMax d2 T3 newAction2) 4)

       ;;patient value  as a property of the edge
       ;;V1 = 9
       (= (patientValue d1 T1 A1) 9)
       (= (patientValue d1 T1 A2) 9)

       ;;V2 = 6
       (= (patientValue d1 T2 G1) 6)
       (= (patientValue d1 T2 A3) 6)

       ;;V3 = 3
       (= (patientValue d2 T3 G2) 3)
       (= (patientValue d2 T3 A7) 3)
       (= (patientValue d2 T3 newAction) 3)
       (= (patientValue d2 T3 newAction2) 3)

       (noPreviousDecision d1)
       ;;(noPreviousAction d1)
       ;;(noPreviousDecision d2)
       (noPreviousAction d2)

       (initialNode d1 T1)
       (initialNode d2 A4)
       (goalNode d1 G1)
       (goalNode d2 G2)

       (predecessorNode T1 A1)
       (predecessorNode T1 A2)
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
       (predecessorNode T3 newAction2)
       (predecessorNode newAction2 G2)

       (decisionNode T1)
       (decisionNode T2)
       (decisionNode T3)

       (actionNode A1)
       (actionNode A2)
       (actionNode A3)
       (actionNode A7)
       (actionNode A4)
       (actionNode newAction)
       (actionNode newAction2)

       (originalAction A1)
       (originalAction A2)
       (originalAction A3)
       (originalAction A7)
       (originalAction A4)

       (revisionAction newAction)
       (revisionAction newAction2)

       ;;Revision (A2+A7, newAction or newAction2): rev1

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
       (= (revisionFlag newAction2 rev1) 0)

       (= (revisionSequenceNumNodes rev1) 2)
       (= (numNodesToReplace rev1) 1)
       (= (revisionCount rev1) 0)
       (= (revisionIDPass d1 rev1) 0)
       (= (revisionIDPass d2 rev1) 0)

       (= (allRevisionsPass d1) 0)
       (= (allRevisionsPass d2) 0)
       (= (numRevisionIDs d1) 1)
       (= (numRevisionIDs d2) 1)

       (anyRevisionOps d1)
       (anyRevisionOps d2)

       (= (tentativeGoalCount) 0)
       (= (numGoals) 2)

       ;;Different cost/metric functions.
       (= (total-cost) 0)
       (= (total-burden) 0)
       (= (total-nonadherence) 0)

       ;;Cost consideration (price of treatment)
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
       (= (nodeCost newAction2) 50)

       ;;Burden consideration (want to minimize burden)
       (= (nodeBurden A1) 0)
       (= (nodeBurden A2) 0)
       (= (nodeBurden A3) 0)
       (= (nodeBurden A7) 0)
       (= (nodeBurden A4) 0)
       (= (nodeBurden T1) 0)
       (= (nodeBurden T2) 0)
       (= (nodeBurden T3) 0)
       (= (nodeBurden G1) 0)
       (= (nodeBurden G2) 0)
       (= (nodeBurden newAction) 0)
       (= (nodeBurden newAction2) 0)

       ;;Non-adherence consideration (want to minimize non-adherence)
       (= (nodeNonAdherence A1) 0)
       (= (nodeNonAdherence A2) 0)
       (= (nodeNonAdherence A3) 0)
       (= (nodeNonAdherence A7) 0)
       (= (nodeNonAdherence A4) 0)
       (= (nodeNonAdherence T1) 0)
       (= (nodeNonAdherence T2) 0)
       (= (nodeNonAdherence T3) 0)
       (= (nodeNonAdherence G1) 0)
       (= (nodeNonAdherence G2) 0)
       (= (nodeNonAdherence newAction) 0)
       (= (nodeNonAdherence newAction2) 0)
)

(:goal (and (treatmentPlanReady d1 G1)
            (treatmentPlanReady d2 G2)
       )
)

(:metric minimize (total-cost))

)

;problem instance consisting of objects, initial and goal requirements.
