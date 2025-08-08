(define (domain mitplan-domain)
     (:requirements :strips :typing :durative-actions :duration-inequalities :fluents :equality :conditional-effects :negative-preconditions :action-costs :adl :time)

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
          ; * newNode - a node that should be entered 
          ; * preActiveNode - a node that has been entered and now should be pre-processed
          ; * activeNode - a node that has been pre-processed and how should be processed (i.e., a clinical decision should be made or a clinical action should be taken)
          ; * postActiveNode - a node that has been processed and now should be post-processed
          ; * completedNode - a node that has been post-processed and now should be marked as completed
          ; 
          ; The following diagram illustrates transitions between node states achieved via specific planning actions:
          ; newNode -> enter-*-node -> preActiveNode -> pre-process-*-node -> activeNode -> process-*-node -> postActiveNode -> post-process-*-node -> completedNode
          (newNode ?d - disease ?node - node)
          (preActiveNode ?d - disease ?node - node)
          (activeNode ?d - disease ?node - node)
          (postActiveNode ?d - disease ?node - node ?succ - node)
          (completedNode ?d - disease ?node - node ?succ - node)

          ;; added
          (leftNode ?d - disease ?node ?succ - node)
          
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

     ;; Activate initial node in a CIG - mark it as a new node
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

     ;; Enter parallel-end  - check if all predecessor nodes are be completed and then mark it as pre-active
     (:event enter-parallel-end-node
          :parameters (?d - disease ?node - node)

          :precondition (and
               (newNode ?d ?node)
               (parallelEndNode ?node)
               (forall (?prev - node)
                    (or 
                    ; prev is not a predecessor of node or prev is completed (we iterate over all existing nodes)
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

     ;; Enter any other node - mark it as pre-active without any additional checks
     (:event enter-other-node
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

     ;; Pre-process any node - mark it as active without any additional checks 
     ;; Currently this action seems to negligible, however, we plan to establish certain temporal properties of processed nodes,
     ;; e.g., their start and stop times, so they can be used in more complex checks for interactions.
     (:event pre-process-any-node
          :parameters (?d - disease ?node - node)

          :precondition (and
               (preActiveNode ?d ?node)
          )

          :effect (and
               (not (preActiveNode ?d ?node))
               (activeNode ?d ?node)
          )
     )

     ;; Post-process action node if at least one revision operator has been applied to a given CIG - check if no interactions have been triggered so far,
     ;; update total costs and mark the node as completed
     (:event post-process-action-node-any-revs
          :parameters (?d - disease ?node - node ?succ - node)

          :precondition (and
               (postActiveNode ?d ?node ?succ)
               (actionNode ?node)
               (anyRevisionOps ?d) ; statically true or false in the initial state
               ; We check for interactions early and allow to continue pursuing a given path only if the current node does not trigger any interaction, 
               ; or no interaction it may trigger has been triggered so far.
               (forall (?rev - revID) 
                    (or 
                         (= (revisionFlag ?node ?rev) 0)
                         (< (revisionCount ?rev) (revisionSequenceNumNodes ?rev))
                    )
               )
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

     ;; Post process action node if no revision operators have been applied to a given CIG - update total costs and mark the node as completed
     ;; Not none have been applied, this isn't added when one is, it's just determined in the initial state whether they are to be applied or not in this state
     (:event post-process-action-node-no-revs
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

     ;; Post-process other node - simply mark the node as completed. Costs are not updated, as they are meaningful only for action nodes.
     (:event post-process-other-node
          :parameters (?d - disease ?node - node ?succ - node)

          :precondition (and
               (postActiveNode ?d ?node ?succ)
               (not (actionNode ?node))
          )

          :effect (and
               (not (postActiveNode ?d ?node ?succ))
               (completedNode ?d ?node ?succ)
          )
     )

     ;; Leave (any) node - mark the successor node as new
     (:event leave-node
          :parameters (?d - disease ?node - node ?succ - Node)

          :precondition (and
               (not (leftNode ?d ?node ?succ)) ;prevent repeatedly leaving a node
               (completedNode ?d ?node ?succ)
               (not (newNode ?d ?succ))
          )

          :effect (and
               (newNode ?d ?succ)
               (leftNode ?d ?node ?succ) ;prevent repeatedly leaving a node
          )
     )

     ;; Process decision node - make a decision based on the value of the associated data item and mark the successor node as active
     (:event process-decision-node
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
     
     ;; Process original action node (that comes from the original CIG) - mark the node as post-active
     (:event process-action-node-original
          :parameters(?d - disease ?node - node ?succ - node)

          :precondition (and
               (actionNode ?node)
               (activeNode ?d ?node)
               (originalAction ?node)
               (triggerCountUpdated ?d ?node)
               (predecessorNode ?node ?succ)
               (forall (?rev_op - revID)                  ; I added this but not sure if it's necessary (I think I 
                    (not (revisionAction ?node ?rev_op))  ; initially misunderstood how the revisions were modelled).
               )                                          ; so feel free to remove if not necessary
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )

     ;; Process revised action node (introduced by a revision operator) - mark the node as post-active. 
     ;; It is similar to process-action-node-original, however, in a generated plan it clearly indicates a revised action together with a revision operator that introduced it.
     (:action process-action-node-revised
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

     ;; Process parallel start node - mark all successor nodes for further processing
     (:event process-parallel-start-node
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

     ;; Process parallel-end node - mark it as post-active, now only applies to parallel ends, dummys handled separately
     (:event process-other-node
          :parameters(?d - disease ?node - node ?succ - node)

          :precondition (and
               (activeNode ?d ?node)
               (parallelEndNode ?node)
               (predecessorNode ?node ?succ)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )
     
     ;; Process dummy node - mark it as post-active, newly separated, as I undestand it the choice is betwen using
     ;; this action to 'skip' the revision or using the action to take it so this needs to be an explicit decision.
     (:action skip-revision-dummy-node
          :parameters(?d - disease ?node - node ?succ - node)

          :precondition (and
                    (activeNode ?d ?node)
                    (dummyNode ?node)
                    (predecessorNode ?node ?succ)
          )

          :effect (and
               (not (activeNode ?d ?node))
               (postActiveNode ?d ?node ?succ)
          )
     )

     ;; Process goal node - indicate that the goal has been reached
     (:event process-goal-node
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

     ;; Update the number of triggered conditions in revision operators for a given action node
     ;; If we're only counting the number here (i.e. revisionFlag will never be anything other 
     ;; than 1 or 0, we could avoid having to define all the zero variables for revision flag by 
     ;; making a revisionDone predicate (added by the action that does the revision) a trigger for the increase:                  
     ;; (forall (?rev - revID) (when (revisionDone ?node ?rev) (increase (revisionCount ?rev) 1))) 
     ;; or is what we're modelling more subtle than that?    
     (:event update-trigger-count
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

     ;; Indicate that a treatment plan for a given disease has been created. Seems redundant given the reachedGoal predicate.
     ;; Kept for consistency with older examples.
     ;;
     (:event final-goal-reached
          :parameters (?x - disease ?goal - node)

          :precondition (reachedGoal ?x ?goal)

          :effect (and 
                       (treatmentPlanReady ?x ?goal) 
                       (not (reachedGoal ?x ?goal)) ; prevent the goal event repeatedly firing
                  )
     )
)
