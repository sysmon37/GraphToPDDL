(define (domain simpleCPG-domain)
(:requirements :strips :typing :durative-actions :duration-inequalities :fluents :equality :conditional-effects :negative-preconditions :action-costs :adl)

(:types disease node revID DataItem - object)

(:predicates (treatmentPlanReady ?x - disease ?goal - node)

             (tentativeGoal ?x - disease ?goal - node)
             (reachedGoal ?x - disease ?goal - node)

             (initialNode ?x - disease ?first - node)
             (goalNode ?x - disease ?endnode - node)
             (decisionNode ?dec - node)
             (actionNode ?act - node)
             (predecessorNode ?prec - node ?succ - node)
             (activeNode ?x - disease ?current - node)

             (originalAction ?act - node)
             (revisionAction ?act - node ?rev_op - revID)

             (revisionIDCounted ?x - disease ?prec - node ?succ - node)
             (anyRevisionOps ?x - disease)
             (noRevisionOps ?x - disease)
; Associates a data item with a specific decision node
             (dataItem ?n - node ?item - DataItem)

             (completedNode ?d - disease ?completed - node ?new - node)
             (newNode ?d - disease ?new - node)

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
; Returns a value of a specific data item
            (dataValue ?item - DataItem)
)

;; Activate initial node
(:action activate-initial-node
     :parameters (?d - disease ?node - node)

     :precondition (and
          (initialNode ?d ?node)
     )

     :effect (and
          (not (initialNode ?d ?node))
          (newNode ?d ?node)
     )
)

;; Post-process action node
(:action post-process-action-node
     :parameters (?d - disease ?from_node - node ?to_node - node)

     :precondition (and
          (completedNode ?d ?from_node ?to_node)
          (actionNode ?from_node)
     )

     :effect (and
          (not (completedNode ?d ?from_node ?to_node))
          (newNode ?d ?to_node)
          (increase (total-execcost) (nodeExecCost ?from_node))
          (increase (total-cost) (nodeCost ?from_node))
          (increase (total-burden) (nodeBurden ?from_node))
          (increase (total-nonadherence) (nodeNonAdherence ?from_node))
     )
)

;; Post-process other node
(:action post-process-other-node
     :parameters (?d - disease ?from_node - node ?to_node - node)

     :precondition (and
          (completedNode ?d ?from_node ?to_node)
          (not (actionNode ?from_node))
     )

     :effect (and
          (not (completedNode ?d ?from_node ?to_node))
          (newNode ?d ?to_node)
     )
)

;; Pre-process goal node
(:action pre-process-goal-node
     :parameters (?d - disease ?to_node - node)

     :precondition (and
          (newNode ?d ?to_node)
          (goalNode ?d ?to_node)
     )

     :effect (and
        (not (newNode ?d ?to_node))
        (activeNode ?d ?to_node)
        (increase (tentativeGoalCount) 1)
        (tentativeGoal ?d ?to_node)
     )
)

;; Pre-process goal node
(:action pre-process-other-node
     :parameters (?d - disease ?to_node - node)

     :precondition (and
          (newNode ?d ?to_node)
          (not (goalNode ?d ?to_node))
     )

     :effect (and
        (not (newNode ?d ?to_node))
        (activeNode ?d ?to_node)
     )
)

;;
;;Going from a decision node to an action node.
;;
(:durative-action make-decision :parameters(?x - disease ?from_node - node ?to_node - node ?item - DataItem)

  :duration (= ?duration 0)

  :condition (and 
                    (at start (activeNode ?x ?from_node))
                    (at start (predecessorNode ?from_node ?to_node))
                    (at start (decisionNode ?from_node))
                    (at start (dataItem ?from_node ?item))
                    (at start (>= (dataValue ?item) (decisionBranchMin ?x ?from_node ?to_node)))
                    (at start (<= (dataValue ?item) (decisionBranchMax ?x ?from_node ?to_node)))
             )

  :effect (and
                (at end (not (activeNode ?x ?from_node)))
                (at end (completedNode ?x ?from_node ?to_node))
          )
)

;;
;; Take original action
;;
(:durative-action take-original-action :parameters(?x - disease ?from_node - node ?to_node - node)

  :duration (= ?duration (nodeDuration ?from_node))

  :condition (and
                (at start (activeNode ?x ?from_node))
                (at start (predecessorNode ?from_node ?to_node))
                (at start (actionNode ?from_node))
                (at start (originalAction ?from_node))
                (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and
                (at end (not (activeNode ?x ?from_node)))
                (at end (completedNode ?x ?from_node ?to_node))
          )
)

;;
;; Take original action
;;
(:durative-action take-revised-action :parameters(?x - disease ?from_node - node ?to_node - node ?rev_op - revID)

  :duration (= ?duration (nodeDuration ?from_node))

  :condition (and
                (at start (activeNode ?x ?from_node))
                (at start (predecessorNode ?from_node ?to_node))
                (at start (actionNode ?from_node))
                (at start (revisionAction ?from_node ?rev_op))
                (at start (revisionIDCounted ?x ?from_node ?to_node))
             )

  :effect (and
                (at end (not (activeNode ?x ?from_node)))
                (at end (completedNode ?x ?from_node ?to_node))
          )
)

;;
;;Code for checking adverse interactions and confirming goals.
;;
(:durative-action check-adverse-interaction :parameters(?x - disease ?goal - node ?y - revID)

  :duration (= ?duration 0)

  :condition (and (at start (goalNode ?x ?goal))
                  (at start (activeNode ?x ?goal))
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

(:action check-goal :parameters(?x - disease ?goal - node ?y - revID)

  :precondition (and (goalNode ?x ?goal)
                     (activeNode ?x ?goal)
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

(:action check-goal-no-rev-ops :parameters(?x - disease ?goal - node)

  :precondition (and (goalNode ?x ?goal)
                     (activeNode ?x ?goal)
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
(:action check-revisions :parameters(?x - disease ?from_node - node ?to_node - node)

  :precondition (and (predecessorNode ?from_node ?to_node)
                     (actionNode ?from_node)
                     (activeNode ?x ?from_node)
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
(:action final-goal-reached :parameters(?x - disease ?goal - node)
  :precondition (reachedGoal ?x ?goal)

  :effect (treatmentPlanReady ?x ?goal)
)

)
