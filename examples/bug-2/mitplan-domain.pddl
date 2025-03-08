(define (domain mitplan-domain)
     (:requirements :strips :typing :durative-actions :duration-inequalities :fluents :equality :conditional-effects :negative-preconditions :action-costs :adl)

     (:types
          disease node revID DataItem - object
     )

     (:predicates
          (treatmentPlanReady ?x - disease ?goal - node)

          (tentativeGoal ?x - disease ?goal - node)
          (reachedGoal ?x - disease ?goal - node)

          (initialNode ?x - disease ?first - node)
          (goalNode ?x - disease ?endnode - node)
          (decisionNode ?dec - node)
          (actionNode ?act - node)
          ; Dummy (do nothing) node
          (dummyNode ?dummy - node)
          (predecessorNode ?prec - node ?succ - node)

          (originalAction ?act - node)
          (revisionAction ?act - node ?rev_op - revID)

          ; Parallel blocks
          (parallelStartNode ?n - node)
          (parallelEndNode ?n - node)

          (triggerCountUpdated ?d - disease ?node - node)
          (anyRevisionOps ?x - disease)
          (noRevisionOps ?x - disease)
          ; Associates a data item with a specific decision node
          (dataItem ?n - node ?item - DataItem)

          ; Node states
          (newNode ?d - disease ?node - node)
          (preActiveNode ?d - disease ?node - node)
          (activeNode ?d - disease ?node - node)
          (postActiveNode ?d - disease ?node - node ?succ - node)
          (completedNode ?d - disease ?node - node ?succ - node)

     )

     (:functions
          (decisionBranchMin ?x - disease ?from - node ?to - node)
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

     ;; Enter node
     (:action enter-parallel-end-node
          :parameters (?d - disease ?node - node)

          :precondition (and
               (newNode ?d ?node)
               (parallelEndNode ?node)
               (forall (?prev - node)
                    (or 
                         (not (predecessorNode ?prev ?node))
                         (completedNode ?d ?prev ?node)
                    )
               )
          )

          :effect (and
               (not (newNode ?d ?node))
               (preActiveNode ?d ?node)
          )
     )

     (:action enter-other-node
          :parameters (?d - disease ?node - node)

          :precondition (and
               (newNode ?d ?node)
               (not (parallelEndNode ?node))
          )

          :effect (and
               (not (newNode ?d ?node))
               (preActiveNode ?d ?node)
          )
     )

     ;; Pre-process goal node
     ; (:action pre-process-goal-node
     ;      :parameters (?d - disease ?node - node)

     ;      :precondition (and
     ;           (preActiveNode ?d ?node)
     ;           (goalNode ?d ?node)
     ;      )

     ;      :effect (and
     ;           (not (preActiveNode ?d ?node))
     ;           (activeNode ?d ?node)
     ;           (increase (tentativeGoalCount) 1)
     ;           (tentativeGoal ?d ?node)
     ;      )
     ; )

     ;; Pre-process other node
     ; (:action pre-process-other-node
     ;      :parameters (?d - disease ?node - node)

     ;      :precondition (and
     ;           (preActiveNode ?d ?node)
     ;           (not (goalNode ?d ?node))
     ;      )

     ;      :effect (and
     ;           (not (preActiveNode ?d ?node))
     ;           (activeNode ?d ?node)
     ;      )
     ; )


     ;; Pre-process any node
     (:action pre-process-any-node
          :parameters (?d - disease ?node - node)

          :precondition (and
               (preActiveNode ?d ?node)
          )

          :effect (and
               (not (preActiveNode ?d ?node))
               (activeNode ?d ?node)
          )
     )

     ;; Post-process action node
     (:action post-process-action-node-any-revs
          :parameters (?d - disease ?node - node ?succ - node)

          :precondition (and
               (postActiveNode ?d ?node ?succ)
               (actionNode ?node)
               (anyRevisionOps ?d)
               ; Early check for intractions
               (forall (?rev - revID) (< (revisionCount ?rev) (revisionSequenceNumNodes ?rev)))
          )

          :effect (and
               (not (postActiveNode ?d ?node ?succ))
               (increase (total-cost) (nodeCost ?node))
               (increase (total-execcost) (nodeExecCost ?node))
               (increase (total-burden) (nodeBurden ?node))
               (increase (total-nonadherence) (nodeNonAdherence ?node))
               (completedNode ?d ?node ?succ)
          )
     )

     (:action post-process-action-node-no-revs
          :parameters (?d - disease ?node - node ?succ - node)

          :precondition (and
               (postActiveNode ?d ?node ?succ)
               (actionNode ?node)
               (noRevisionOps ?d)
          )

          :effect (and
               (not (postActiveNode ?d ?node ?succ))
               (increase (total-cost) (nodeCost ?node))
               (increase (total-execcost) (nodeExecCost ?node))
               (increase (total-burden) (nodeBurden ?node))
               (increase (total-nonadherence) (nodeNonAdherence ?node))
               (completedNode ?d ?node ?succ)
          )
     )

     (:action post-process-dummy-node
          :parameters (?d - disease ?node - node ?succ - node)

          :precondition (and
               (postActiveNode ?d ?node ?succ)
               (dummyNode ?node)
               (noRevisionOps ?d)
          )

          :effect (and
               (not (postActiveNode ?d ?node ?succ))
               (increase (total-cost) (nodeCost ?node))
               (increase (total-execcost) (nodeExecCost ?node))
               (increase (total-burden) (nodeBurden ?node))
               (increase (total-nonadherence) (nodeNonAdherence ?node))
               (completedNode ?d ?node ?succ)
          )
     )

     ;; Post-process other node
     (:action post-process-other-node
          :parameters (?d - disease ?node - node ?succ - node)

          :precondition (and
               (postActiveNode ?d ?node ?succ)
               (not (actionNode ?node))
          )

          :effect (and
               (not (postActiveNode ?d ?node ?succ))
               (completedNode ?d ?node ?succ)
               (increase (total-cost) (nodeCost ?node))
          )
     )

     ;; Leave (any) node
     (:action leave-node
          :parameters (?d - disease ?node - node ?succ - Node)

          :precondition (and
               (completedNode ?d ?node ?succ)
               (not (newNode ?d ?succ))
          )

          :effect (and
               (newNode ?d ?succ)
          )
     )

     ;;
     ;; Process decision node
     ;;
     (:action make-decision
          :parameters (?d - disease ?node - node ?succ - node ?item - DataItem)

          :precondition (and
               (decisionNode ?node)
               (activeNode ?d ?node)
               (predecessorNode ?node ?succ)
               (dataItem ?node ?item)
               (>= (dataValue ?item) (decisionBranchMin ?d ?node ?succ))
               (<= (dataValue ?item) (decisionBranchMax ?d ?node ?succ))
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )

     ;;
     ;; Process original action node
     ;;
     ; (:durative-action take-original-action
     ;      :parameters(?d - disease ?node - node ?succ - node)

     ;      :duration (= ?duration (nodeDuration ?node))

     ;      :condition (and
     ;           (at start (actionNode ?node))
     ;           (at start (activeNode ?d ?node))
     ;           (at start (originalAction ?node))
     ;           (at start (triggerCountUpdated ?d ?node))
     ;           (at start (predecessorNode ?node ?succ))
     ;      )

     ;      :effect (and
     ;           (at end (not (activeNode ?d ?node)))
     ;           (at end (postActiveNode ?d ?node ?succ))
     ;      )
     ; )

     ; ;;
     ; ;; Process revised action node
     ; ;;
     ; (:durative-action take-revised-action
     ;      :parameters (?d - disease ?node - node ?succ - node ?rev - revID)

     ;      :duration (= ?duration (nodeDuration ?node))

     ;      :condition (and
     ;           (at start (actionNode ?node))
     ;           (at start (activeNode ?d ?node))
     ;           (at start (revisionAction ?node ?rev))
     ;           (at start (predecessorNode ?node ?succ))
     ;           (at start (triggerCountUpdated ?d ?node))
     ;      )

     ;      :effect (and
     ;           (at end (not (activeNode ?d ?node)))
     ;           (at end (postActiveNode ?d ?node ?succ))
     ;      )
     ; )

     (:action take-original-action
          :parameters(?d - disease ?node - node ?succ - node)

          :precondition (and
               (actionNode ?node)
               (activeNode ?d ?node)
               (originalAction ?node)
               (triggerCountUpdated ?d ?node)
               (predecessorNode ?node ?succ)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )

     ;;
     ;; Process revised action node
     ;;
     (:action take-revised-action
          :parameters (?d - disease ?node - node ?succ - node ?rev - revID)

          :precondition (and
               (actionNode ?node)
               (activeNode ?d ?node)
               (revisionAction ?node ?rev)
               (predecessorNode ?node ?succ)
               (triggerCountUpdated ?d ?node)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )

     ;; Process parallel start node
     (:action process-parallel-start-node
          :parameters(?d - disease ?node - node)

          :precondition (and
               (activeNode ?d ?node)
               (parallelStartNode ?node)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (forall (?succ - node)
                    (when 
                         (predecessorNode ?node ?succ)
                         (postActiveNode ?d ?node ?succ)
                    )
               )

          )
     )

     ;; Process other (parallel-end and dummy) node
     (:action process-other-node
          :parameters(?d - disease ?node - node ?succ - node)

          :precondition (and
               (activeNode ?d ?node)
               (or 
                    (parallelEndNode ?node)
                    (dummyNode ?node)
               )
               (predecessorNode ?node ?succ)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )

     ;; Process goal node
     (:action process-goal-node
          :parameters(?d - disease ?node - node)

          :precondition (and
               (activeNode ?d ?node)
               (goalNode ?d ?node)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (reachedGoal ?d ?node)
          )
     )
     ;;
     ;; Check for adverse interactions and confirming goals.
     ;;
     ; (:action check-adverse-interaction
     ;      :parameters (?x - disease ?goal - node ?y - revID)

     ;      :precondition (and 
     ;           (goalNode ?x ?goal)
     ;           (activeNode ?x ?goal)
     ;           (tentativeGoal ?x ?goal)
     ;           ;(at start (<= (revisionCount ?y) 1))
     ;           ; (<= (revisionCount ?y) (- (revisionSequenceNumNodes ?y) (numNodesToReplace ?y)))
     ;           (< (revisionCount ?y) (revisionSequenceNumNodes ?y))
     ;           (= (tentativeGoalCount) numGoals)
     ;           (= (revisionIDPass ?x ?y) 0)
     ;           (anyRevisionOps ?x)
     ;      )

     ;      :effect (and 
     ;           (increase (revisionIDPass ?x ?y) 1)
     ;           (increase (allRevisionsPass ?x) 1)
     ;      )
     ; )

     ; (:action check-goal-node-any-revs
     ;      :parameters (?d - disease ?node - node)

     ;      :precondition (and 
     ;           (activeNode ?d ?node)
     ;           (goalNode ?d ?node)
     ;           (tentativeGoal ?d ?node)
     ;           (not (goalChecked ?d ?node))
     ;           (= (tentativeGoalCount) numGoals)
     ;           (anyRevisionOps ?d)
     ;      )

     ;      :effect (and
     ;           (reachedGoal ?d ?node)
     ;           (not (tentativeGoal ?d ?node))
     ;      )
     ; )


     ; (:action check-goal-any-revs
     ;      :parameters (?x - disease ?goal - node ?y - revID)

     ;      :precondition (and 
     ;           (goalNode ?x ?goal)
     ;           (activeNode ?x ?goal)
     ;           (tentativeGoal ?x ?goal)
     ;           ;(<= (revisionCount ?y) 1)
     ;           ; (<= (revisionCount ?y) (- (revisionSequenceNumNodes ?y) (numNodesToReplace ?y)))
     ;           (< (revisionCount ?y) (revisionSequenceNumNodes ?y))
     ;           (= (tentativeGoalCount) numGoals)
     ;           (= (allRevisionsPass ?x) (numRevisionIDs ?x))
     ;           (anyRevisionOps ?x)
     ;      )

     ;      :effect (and 
     ;           (reachedGoal ?x ?goal)
     ;           (not (tentativeGoal ?x ?goal))
     ;      )
     ; )


     ; (:action check-goal-node-no-revs
     ;      :parameters (?d - disease ?node - node)

     ;      :precondition (and 
     ;           (goalNode ?d ?node)
     ;           (activeNode ?d ?node)
     ;           (tentativeGoal ?d ?node)
     ;           (not (goalChecked ?d ?node))
     ;           (= (tentativeGoalCount) numGoals)
     ;           (noRevisionOps ?d)
     ;      )

     ;      :effect (and 
     ;           (reachedGoal ?d ?node)
     ;           (not (tentativeGoal ?d ?node))
     ;           ; (goalChecked ?d ?node)
     ;      )              
     ; )

     ;;
     ;;Previously named countRevisions.
     ;;
     (:action update-trigger-count
          :parameters (?d - disease ?node - node)

          :precondition (and 
               (actionNode ?node)
               (activeNode ?d ?node)
               (not (triggerCountUpdated ?d ?node))
          )

          :effect (and 
               (forall (?rev - revID)
                    (when (> 1 0)
                         (increase
                              (revisionCount ?rev)
                              (revisionFlag ?node ?rev))))
               (triggerCountUpdated ?d ?node)
          )
     )

     ;;
     ;;Goal reached. The treatment plan for disease x is ready.
     ;;
     (:action final-goal-reached
          :parameters (?x - disease ?goal - node)

          :precondition (reachedGoal ?x ?goal)

          :effect (treatmentPlanReady ?x ?goal)
     )
)