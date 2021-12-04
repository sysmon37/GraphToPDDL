(define (domain simpleCPG22-domain)
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

             (anyRevisionOps ?x - disease)
             (noRevisionOps ?x - disease)
             (revisionIDCounted ?x - disease ?prec - node ?succ - node)
             (revisionIDCountedParallelBlock ?x - disease ?prev_precnode - node ?prec - node ?succ - node)

             (inParallelBlock ?x - disease)
             (parallelStartNode ?n - node)
             (parallelEndNode ?n - node)
             (parallelActionNode ?n - node)
             (parallelDecisionNode ?n - node)
             (untraversedParallelNode ?n - node)
             (traversedParallelNode ?n - node)
             (sameParallelBlockNodes ?start - node ?end - node)
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

            (parallelPathCount ?n - node ?x - disease)
            (numParallelPaths ?n - node ?x - disease)

            (tentativeGoalCount)
            (numGoals)

            (nodeCost ?n - node)
            (total-cost)

            (nodeBurden ?n - node)
            (total-burden)

            (nodeNonAdherence ?n - node)
            (total-nonadherence)
)

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
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

(:durative-action makeDecisionToActionNode :parameters(?x - disease ?from_node - node ?to_node - node)

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
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

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
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

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
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (tentativeGoalCount) 1))
          )
)

(:durative-action takeFirstAction :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (noPreviousAction ?x))
                  (at start (initialNode ?x ?from_node))
                  (at start (actionNode ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (noPreviousAction ?x)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

(:durative-action takeActionToActionNode :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (predecessorNode ?from_node ?to_node))
                  (at start (actionNode ?from_node))
                  (at start (actionNode ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

(:durative-action takeActionToDecisionNode :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (predecessorNode ?from_node ?to_node))
                  (at start (actionNode ?from_node))
                  (at start (decisionNode ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

(:durative-action takeActionToGoal :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (actionNode ?from_node))
                  (at start (goalNode ?x ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (tentativeGoal ?x ?to_node))
               (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (tentativeGoalCount) 1))
          )
)

;;
;; Code for parallel block
;;

(:durative-action takeActionToParallelBlock :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (actionNode ?from_node))
                  (at start (parallelStartNode ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

(:durative-action makeDecisionToParallelBlock :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (>= (patientValue ?x ?from_node ?to_node)(decisionBranchMin ?x ?from_node ?to_node)))
                  (at start (<= (patientValue ?x ?from_node ?to_node)(decisionBranchMax ?x ?from_node ?to_node)))
                  (at start (decisionNode ?from_node))
                  (at start (parallelStartNode ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
          )
)

;;Enter the parallel block at the parallel start node.

(:durative-action executeParallelStartNode :parameters(?x - disease ?from_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelStartNode ?from_node))
                  (at start (currentNode ?x ?from_node))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               ;(at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (inParallelBlock ?x))
               (at end (traversedParallelNode ?from_node))
          )
)

;;Go from one parallel action node to another. The action being taken is from_node.

(:durative-action takeParallelAction :parameters(?x - disease ?prev_node - node ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelActionNode ?from_node))
                  (at start (parallelActionNode ?to_node))
                  (at start (predecessorNode ?prev_node ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (inParallelBlock ?x))
                  (at start (untraversedParallelNode ?from_node))
                  (at start (traversedParallelNode ?prev_node))
                  (at start (revisionIDCountedParallelBlock ?x ?prev_node ?from_node ?to_node))
             )

  :effect (and (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (not (untraversedParallelNode ?from_node)))
               (at end (traversedParallelNode ?from_node))
          )
)

;;Go from one parallel action node to another. The action being taken is from_node. The case with no revisions.

(:durative-action takeParallelActionNoRevisions :parameters(?x - disease ?prev_node - node ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelActionNode ?from_node))
                  (at start (parallelActionNode ?to_node))
                  (at start (predecessorNode ?prev_node ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (inParallelBlock ?x))
                  (at start (untraversedParallelNode ?from_node))
                  (at start (traversedParallelNode ?prev_node))
                  (at start (noRevisionOps ?x))
             )

  :effect (and (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (not (untraversedParallelNode ?from_node)))
               (at end (traversedParallelNode ?from_node))
          )
)

;;Go from a parallel decision node to a parallel action node. The decision being taken is from_node.

(:durative-action makeParallelDecision :parameters(?x - disease ?prev_Node - node ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelDecisionNode ?from_node))
                  (at start (parallelActionNode ?to_node))
                  (at start (predecessorNode ?prev_node ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (inParallelBlock ?x))
                  (at start (untraversedParallelNode ?from_node))
                  (at start (traversedParallelNode ?prev_node))
             )

  :effect (and (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (not (untraversedParallelNode ?from_node)))
               (at end (traversedParallelNode ?from_node))
          )
)

;;Go from the last parallel action in a parallel path to the parallel end node.
;;The action being taken is from_node.

(:durative-action executeParallelEndNode :parameters(?x - disease ?start_node - node ?prev_Node - node ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelActionNode ?from_node))
                  (at start (parallelEndNode ?to_node))
                  (at start (predecessorNode ?prev_node ?from_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (inParallelBlock ?x))
                  (at start (untraversedParallelNode ?from_node))
                  (at start (traversedParallelNode ?prev_node))
                  (at start (parallelStartNode ?start_node))
                  (at start (traversedParallelNode ?start_node))
                  (at start (sameParallelBlockNodes ?start_node ?to_node))
             )

  :effect (and ;(at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (increase (parallelPathCount ?to_node ?x) 1))
               (at end (not (untraversedParallelNode ?from_node)))
               (at end (traversedParallelNode ?from_node))
          )
)

;;Exit the parallel block (so go from parallel end node) to go to an action node.

(:durative-action exitParallelBlockToAction :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelEndNode ?from_node))
                  (at start (actionNode ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (inParallelBlock ?x))
                  (at start (= (parallelPathCount ?from_node ?x) (numParallelPaths ?from_node ?x)))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (not (inParallelBlock ?x)))
          )
)

;;Exit the parallel block (so go from parallel end node) to go to a decision node.

(:durative-action exitParallelBlockToDecision :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelEndNode ?from_node))
                  (at start (decisionNode ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (inParallelBlock ?x))
                  (at start (= (parallelPathCount ?from_node ?x) (numParallelPaths ?from_node ?x)))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (not (inParallelBlock ?x)))
          )
)

;;Exit the parallel block (so go from parallel end node) to go to a goal node.

(:durative-action exitParallelBlockToGoal :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration 0)

  :condition (and (at start (parallelEndNode ?from_node))
                  (at start (goalNode ?x ?to_node))
                  (at start (predecessorNode ?from_node ?to_node))
                  (at start (currentNode ?x ?from_node))
                  (at start (inParallelBlock ?x))
                  (at start (= (parallelPathCount ?from_node ?x) (numParallelPaths ?from_node ?x)))
             )

  :effect (and (at end (not (currentNode ?x ?from_node)))
               (at end (currentNode ?x ?to_node))
               (at end (increase (total-cost) (nodeCost ?from_node)))
               (at end (increase (total-burden) (nodeBurden ?from_node)))
               (at end (increase (total-nonadherence) (nodeNonAdherence ?from_node)))
               (at end (not (inParallelBlock ?x)))
               (at end (tentativeGoal ?x ?to_node))
               (at end (increase (tentativeGoalCount) 1))
          )
)

;;
;; Code for adverse interactions and confirming goals
;;

(:durative-action checkAdverseInteraction :parameters(?x - disease ?goal - node ?y - revID)

  :duration (= ?duration 0)

  :condition (and (at start (goalNode ?x ?goal))
                  (at start (currentNode ?x ?goal))
                  (at start (tentativeGoal ?x ?goal))
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

;;previously named countRevisions

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

;;previously named countRevisionsFirstAction

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

;;Specially for actions inside a parallel block.

(:action checkRevisionsParallel :parameters(?x - disease ?prev_node - node ?from_node - node ?to_node - node)

  :precondition (and (parallelActionNode ?from_node)
                     (parallelActionNode ?to_node)
                     (predecessorNode ?prev_node ?from_node)
                     (predecessorNode ?from_node ?to_node)
                     (inParallelBlock ?x)
                     (untraversedParallelNode ?from_node)
                     (traversedParallelNode ?prev_node)
                )

  :effect (and (forall (?y - revID)
                  (when (> 1 0)
                    (increase (revisionCount ?y) (revisionFlag ?from_node ?y))))
                (revisionIDCountedParallelBlock ?x ?prev_node ?from_node ?to_node)
          )
)


(:action finalGoalReached :parameters(?x - disease ?goal - node)
  :precondition (reachedGoal ?x ?goal)

  :effect (treatmentPlanReady ?x ?goal)
)

)
