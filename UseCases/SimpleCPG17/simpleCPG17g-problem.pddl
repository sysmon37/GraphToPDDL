(define (problem simpleCPG17-problem)
    (:domain simpleCPG17-domain)

(:objects d - disease
          CHA2SDS2 ALTX12 ASP WARF DABI G - node
)

(:init (= (decisionBranchMin d CHA2SDS2 ASP) 0)
       (= (decisionBranchMax d CHA2SDS2 ASP) 0.99)
       (= (decisionBranchMin d CHA2SDS2 ALTX12) 1)
       (= (decisionBranchMax d CHA2SDS2 ALTX12) 10)

       (= (decisionBranchMin d ALTX12 WARF) 0)
       (= (decisionBranchMax d ALTX12 WARF) 5)
       (= (decisionBranchMin d ALTX12 DABI) 0)
       (= (decisionBranchMax d ALTX12 DABI) 5)

       ;;patient value  as a property of the edge
       ;;V1 = 1
       (= (patientValue d CHA2SDS2 ASP) 1)
       (= (patientValue d CHA2SDS2 ALTX12) 1)

       ;;V2 = 3
       (= (patientValue d ALTX12 WARF) 3)
       (= (patientValue d ALTX12 DABI) 3)

       (noPreviousDecision d)
       ;;(noPreviousAction d)

       (initialNode d CHA2SDS2)
       (goalNode d G)

       (predecessorNode CHA2SDS2 ASP)
       (predecessorNode CHA2SDS2 ALTX12)
       (predecessorNode ASP G)
       (predecessorNode ALTX12 WARF)
       (predecessorNode ALTX12 DABI)
       (predecessorNode WARF G)
       (predecessorNode DABI G)

       (decisionNode CHA2SDS2)
       (decisionNode ALTX12)

       (actionNode ASP)
       (actionNode WARF)
       (actionNode DABI)

       (= (allRevisionsPass d) 0)
       (= (numRevisionIDs d) 0)
       (noRevisionOps d)

       (= (tentativeGoalCount) 0)
       (= (numGoals) 1)

       ;;Different cost/metric functions.
       (= (total-cost) 0)
       (= (total-burden) 0)
       (= (total-nonadherence) 0)

       ;;Cost consideration (price of treatment)
       (= (nodeCost CHA2SDS2) 0)
       (= (nodeCost ASP) 10)
       (= (nodeCost ALTX12) 0)
       (= (nodeCost G) 0)
       (= (nodeCost WARF) 55)
       (= (nodeCost DABI) 1200)

       ;;Burden consideration (want to minimize burden)
       (= (nodeBurden CHA2SDS2) 0)
       (= (nodeBurden ASP) 0)
       (= (nodeBurden ALTX12) 0)
       (= (nodeBurden G) 0)
       (= (nodeBurden WARF) 500)
       (= (nodeBurden DABI) 10)

       ;;Non-adherence consideration (want to minimize non-adherence)
       (= (nodeNonAdherence CHA2SDS2) 0)
       (= (nodeNonAdherence ASP) 0)
       (= (nodeNonAdherence ALTX12) 0)
       (= (nodeNonAdherence G) 0)
       (= (nodeNonAdherence WARF) 20)
       (= (nodeNonAdherence DABI) 100)
)

(:goal (treatmentPlanReady d G)
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

(:metric minimize (+ (* 1 total-cost) (* 0 total-burden) (* 0 total-nonadherence)))
)
