(define (domain simpleCPG-domain)
(:requirements :strips :typing :durative-actions :duration-inequalities :fluents :equality :conditional-effects :negative-preconditions :action-costs :adl)

(:types disease node revID - object)

(:predicates (treatmentPlanReady ?x - disease ?goal - node)
             (noPreviousAction ?x - disease)
             (noPreviousDecision ?x - disease)

             (tentativeGoal ?x - disease ?goal - node)
             (reachedGoal ?x - disease ?goal - node)

             (initialNode ?x - disease ?first - node)
             (goalNode ?x - disease ?endnode - node)
             (decisionNode ?dec - node)
             (actionNode ?act - node)
             (predecessorNode ?prec - node ?succ - node)
             (currentNode ?x - disease ?current - node)

             (originalAction ?act - node)
             (revisionAction ?act - node)

             (revisionIDCounted ?x - disease ?prec - node ?succ - node)
             (anyRevisionOps ?x - disease)
             (noRevisionOps ?x - disease)

)

(:functions (decisionBranchMin ?x - disease ?from - node ?to - node)
            (decisionBranchMax ?x - disease ?from - node ?to - node)
            (patientValue ?x - disease ?from - node ?to - node)

            (revisionFlag ?n - node, ?id - revID)
            (revisionSequenceNumNodes ?id - revID)
            (numNodesToReplace ?id - revID)
            (revisionCount ?id - revID)
            (revisionIDPass ?x - disease ?id - revID)
            (allRevisionsPass ?x - disease)
            (numRevisionIDs ?x - disease)

            (tentativeGoalCount)
            (numGoals)

            (nodeExecCost ?n - node)
            (total-execcost)

            (nodeCost ?n - node)
            (total-cost)

            (nodeBurden ?n - node)
            (total-burden)

            (nodeNonAdherence ?n - node)
            (total-nonadherence)

            (nodeDuration ?n - node)
            (total-duration)

            (nodeStartTime ?n - node)
            (nodeEndTime ?n - node)
)


;;
;;The first decision node encountered by the planner.
;;
(:durative-action makeFirstDecision :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (noPreviousDecision ?x))
                  (at start (>= (patientValue ?x ?from_node ?to_node)(decisionBranchMin ?x ?from_node ?to_node)))
                  (at start (<= (patientValue ?x ?from_node ?to_node)(decisionBranchMax ?x ?from_node ?to_node)))
                  (at start (initialNode ?x ?from_node))
                  (at start (decisionNode ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
             )

  :effect (and (at end (not (noPreviousDecision ?x)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

;;
;;Going from a decision node to an action node.
;;
(:durative-action makeDecisionToNode :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (>= (patientValue ?x ?from_node ?to_node)(decisionBranchMin ?x ?from_node ?to_node)))
                  (at start (<= (patientValue ?x ?from_node ?to_node)(decisionBranchMax ?x ?from_node ?to_node)))
                  (at start (decisionNode ?from_node))
                  (at start (actionNode ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

;;
;;Going from a decision node to a decision node.
;;
(:durative-action makeDecisionToDecisionNode :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (>= (patientValue ?x ?from_node ?to_node)(decisionBranchMin ?x ?from_node ?to_node)))
                  (at start (<= (patientValue ?x ?from_node ?to_node)(decisionBranchMax ?x ?from_node ?to_node)))
                  (at start (decisionNode ?from_node))
                  (at start (decisionNode ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

;;
;;Going from a decision node to the goal node.
;;
(:durative-action makeDecisionToGoal :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (>= (patientValue ?x ?from_node ?to_node)(decisionBranchMin ?x ?from_node ?to_node)))
                  (at start (<= (patientValue ?x ?from_node ?to_node)(decisionBranchMax ?x ?from_node ?to_node)))
                  (at start (decisionNode ?from_node))
                  (at start (goalNode ?x ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
             )

  :effect (and (at end (tentativeGoal ?x ?to_node))
               (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (tentativeGoalCount) 1))
          )
)


;;
;;The first action node encountered by the planner.
;;
(:durative-action takeFirstAction :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration (nodeDuration ?from_node))

  :condition (and (at start (noPreviousAction ?x))
                  (at start (initialNode ?x ?from_node))
                  (at start (actionNode ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (noPreviousAction ?x)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (total-duration) (nodeDuration ?from_node)))
          )
)

;;
;;Previously takeActionToActionNode. Going from an action node to another action
;;node.
;;
(:durative-action takeActionNode :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration (nodeDuration ?from_node))

  :condition (and (at start (predecessorNode ?from_node ?to_node))
                  (at start (actionNode ?from_node))
                  (at start (actionNode ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (total-duration) (nodeDuration ?from_node)))
          )
)

;;
;;Previously takeActionToDecisionNode. Going from an action node to a decision
;;node.
;;
(:durative-action takeActionNodeD :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration (nodeDuration ?from_node))

  :condition (and (at start (predecessorNode ?from_node ?to_node))
                  (at start (actionNode ?from_node))
                  (at start (decisionNode ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (total-duration) (nodeDuration ?from_node)))
          )
)

;;
;;Previously takeActionToGoal. Going from an action node to the goal node.
;;
(:durative-action takeActionNodeG :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration (nodeDuration ?from_node))

  :condition (and (at start (actionNode ?from_node))
                  (at start (goalNode ?x ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (tentativeGoal ?x ?to_node))
               (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-execcost) (nodeExecCost ?from_node)))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (total-duration) (nodeDuration ?from_node)))
               (at end (increase (tentativeGoalCount) 1))
          )
)


;;
;;Code for checking adverse interactions and confirming goals.
;;
(:durative-action checkAdverseInteraction :parameters(?x - disease ?goal - node ?y - revID)

  :duration (= ?duration 0)

  :condition (and (at start (goalNode ?x ?goal))
                  (at start (currentNode ?x ?goal))
                  (at start (tentativeGoal ?x ?goal))
                  ;(at start (<= (revisionCount ?y) 1))
                  (at start (<= (revisionCount ?y) (- (revisionSequenceNumNodes ?y) (numNodesToReplace ?y))))
                  (at start (= (tentativeGoalCount) numGoals))
                  (at start (= (revisionIDPass ?x ?y) 0))
                  (at start (anyRevisionOps ?x))
             )

  :effect (and (at end (increase (revisionIDPass ?x ?y) 1))
               (at end (increase (allRevisionsPass ?x) 1))
          )
)

(:action checkGoal :parameters(?x - disease ?goal - node ?y - revID)

  :precondition (and (goalNode ?x ?goal)
                     (currentNode ?x ?goal)
                     (tentativeGoal ?x ?goal)
                     ;(<= (revisionCount ?y) 1)
                     (<= (revisionCount ?y) (- (revisionSequenceNumNodes ?y) (numNodesToReplace ?y)))
                     (= (tentativeGoalCount) numGoals)
                     (= (allRevisionsPass ?x) (numRevisionIDs ?x))
                     (anyRevisionOps ?x)
                )

  :effect (and (reachedGoal ?x ?goal)
               (not (tentativeGoal ?x ?goal))
          )
)

(:action checkGoalNoRevisionOps :parameters(?x - disease ?goal - node)

  :precondition (and (goalNode ?x ?goal)
                     (currentNode ?x ?goal)
                     (tentativeGoal ?x ?goal)
                     (noRevisionOps ?x)
                )

  :effect (and (reachedGoal ?x ?goal)
               (not (tentativeGoal ?x ?goal))
          )
)

;;
;;Previously named countRevisions.
;;
(:action checkRevisions :parameters(?x - disease ?from_node - node ?to_node - node)

  :precondition (and (predecessorNode ?from_node ?to_node)
                     (actionNode ?from_node)
                     (currentNode ?x ?from_node)
                )

  :effect (and (forall (?y - revID)
                  (when (> 1 0)
                    (increase (revisionCount ?y) (revisionFlag ?from_node ?y))))
                (revisionIDCounted ?x ?from_node ?to_node)
          )
)

;;
;;Previously named countRevisionsFirstAction.
;;
(:action checkRevisionsFirstAction :parameters(?x - disease ?from_node - node ?to_node - node)

  :precondition (and (predecessorNode ?from_node ?to_node)
                     (actionNode ?from_node)
                     (noPreviousAction ?x)
                     (initialNode ?x ?from_node)
                )

  :effect (and (forall (?y - revID)
                  (when (> 1 0)
                    (increase (revisionCount ?y) (revisionFlag ?from_node ?y))))
               (revisionIDCounted ?x ?from_node ?to_node)
          )
)

;;
;;Goal reached. The treatment plan for disease x is ready.
;;
(:action finalGoalReached :parameters(?x - disease ?goal - node)
  :precondition (reachedGoal ?x ?goal)

  :effect (treatmentPlanReady ?x ?goal)
)

)
