(define (problem simpleCPG16-problem)
    (:domain simpleCPG16-domain)

(:objects d1 d2 - disease
          A1 A2 A3 A7 A4 T1 T2 T3 G1 G2 P1 P2 PB1 PB2 PB3 PC1 PC2 PC3 newAction - node
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

       ;;patient value  as a property of the edge
       ;;V1 = 9
       (= (patientValue d1 T1 A1) 9)
       (= (patientValue d1 T1 A2) 9)

       ;;V2 = 6
       (= (patientValue d1 T2 G1) 6)
       (= (patientValue d1 T2 A3) 6)

       ;;V3 = 4
       (= (patientValue d2 T3 G2) 4)
       (= (patientValue d2 T3 A7) 4)
       (= (patientValue d2 T3 newAction) 4)

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
       ;(predecessorNode A1 T2)
       ;(predecessorNode A2 T2)

       (predecessorNode A1 P1)
       (predecessorNode A2 P1)
       (predecessorNode P1 PB1)
       (predecessorNode PB1 PB2)
       (predecessorNode PB2 PB3)
       (predecessorNode PB3 P2)
       (predecessorNode P1 PC1)
       (predecessorNode PC1 PC2)
       (predecessorNode PC2 PC3)
       (predecessorNode PC3 P2)
       (predecessorNode P2 T2)

       (predecessorNode T2 G1)
       (predecessorNode T2 A3)
       (predecessorNode A3 G1)

       (predecessorNode A4 T3)
       (predecessorNode T3 G2)
       (predecessorNode T3 A7)
       (predecessorNode A7 G2)
       (predecessorNode T3 newAction)
       (predecessorNode newAction G2)

       (decisionNode T1)
       (decisionNode T2)
       (decisionNode T3)

       (actionNode A1)
       (actionNode A2)
       (actionNode A3)
       (actionNode A7)
       (actionNode A4)
       (actionNode newAction)

       (originalAction A1)
       (originalAction A2)
       (originalAction A3)
       (originalAction A7)
       (originalAction A4)

       (revisionAction newAction)

       (parallelStartNode P1)
       (parallelEndNode P2)
       (parallelActionNode PB1)
       (parallelActionNode PB2)
       (parallelActionNode PB3)
       (parallelActionNode PC1)
       (parallelActionNode PC2)
       (parallelActionNode PC3)
       (untraversedParallelNode PB1)
       (untraversedParallelNode PB2)
       (untraversedParallelNode PB3)
       (untraversedParallelNode PC1)
       (untraversedParallelNode PC2)
       (untraversedParallelNode PC3)

       ;;Revision (A2+A7, newAction): rev1

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

       (= (revisionFlag P1 rev1) 0)
       (= (revisionFlag P2 rev1) 0)
       (= (revisionFlag PB1 rev1) 0)
       (= (revisionFlag PB2 rev1) 0)
       (= (revisionFlag PB3 rev1) 0)
       (= (revisionFlag PC1 rev1) 0)
       (= (revisionFlag PC2 rev1) 0)
       (= (revisionFlag PC3 rev1) 0)

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

       (= (parallelPathCount d1) 0)
       (= (parallelPathCount d2) 0)
       (= (numParallelPaths d1) 2)
       (= (numParallelPaths d2) 0)
       ;(= (numParallelActionNodes d1) 4)
       ;(= (numParallelActionNodes d2) 0)

       (= (tentativeGoalCount) 0)
       (= (numGoals) 2)

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

       (= (nodeCost P1) 0)
       (= (nodeCost P2) 0)
       (= (nodeCost PB1) 10)
       (= (nodeCost PB2) 10)
       (= (nodeCost PB3) 10)
       (= (nodeCost PC1) 10)
       (= (nodeCost PC2) 10)
       (= (nodeCost PC3) 10)

       (= (total-cost) 0)
)

(:goal (and (treatmentPlanReady d1 G1)
            (treatmentPlanReady d2 G2)
       )
)

(:metric minimize (total-cost))

)

;problem instance consisting of objects, initial and goal requirements.
