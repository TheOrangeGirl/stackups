;; File: stackups.clar

;; A simple savings tracker to deposit STX and track progress towards milestones.

(define-map savings
  { user: principal }
  { balance: uint, milestone: uint, progress: uint })

;; Event definitions
(define-constant DEPOSIT_EVENT "deposit")
(define-constant MILESTONE_SET_EVENT "milestone-set")
(define-constant MILESTONE_ACHIEVED_EVENT "milestone-achieved")

(define-map event-data
  { id: (string-ascii 20), user: principal }
  { value: uint })

;; Private helper functions to emit custom events. The print function simulates event emission.
(define-private (emit-deposit (user principal) (amount uint))
    (begin
        (map-insert event-data { id: DEPOSIT_EVENT, user: user } { value: amount })
        (print { event: DEPOSIT_EVENT, user: user, value: amount })
        (ok true)))

;; Allow users to deposit STX to their savings.
(define-public (deposit (amount uint))
    (let ((current-savings (map-get? savings { user: tx-sender })))
        (if (is-some current-savings)
            ;; Update existing savings balance
            (let ((savings-data (unwrap! current-savings (err "Missing balance")))
                  (current-balance (get balance savings-data))
                  (current-milestone (get milestone savings-data))
                  (current-progress (get progress savings-data))
                  (new-balance (+ current-balance amount)))
                (begin
                    (map-set savings { user: tx-sender }
                        { balance: new-balance, milestone: current-milestone, progress: current-progress })
                    (asserts! (is-ok (emit-deposit tx-sender amount)) (err "Failed to emit deposit event"))
                    (ok amount)))
            (begin
                (print { type: "savings-created", user: tx-sender })
                (map-set savings { user: tx-sender }
                    { balance: amount, milestone: u0, progress: u0 })
                (asserts! (is-ok (emit-deposit tx-sender amount)) (err "Failed to emit deposit event"))
                (ok amount)))))

;; Set a milestone for user savings.
(define-public (set-milestone (milestone uint))
    (let ((current-savings (map-get? savings { user: tx-sender })))
        (if (is-some current-savings)
            (let ((savings-data (unwrap! current-savings (err "Savings data not found")))
                  (current-balance (get balance savings-data))
                  (current-progress (get progress savings-data)))
                (begin
                    (asserts! (> milestone u0) (err "Milestone must be greater than zero"))
                    (map-set savings { user: tx-sender }
                        { balance: current-balance, milestone: milestone, progress: current-progress })
                    (print { event: MILESTONE_SET_EVENT, user: tx-sender, milestone: milestone })
                    (ok milestone)))
            (err "Savings record not found"))))

;; Check if the user has achieved the milestone.
(define-public (check-progress)
    (let ((current-savings (map-get? savings { user: tx-sender })))
        (if (is-some current-savings)
            (let ((savings-data (unwrap! current-savings (err "Savings data not found")))
                  (balance (get balance savings-data))
                  (milestone (get milestone savings-data)))
                (if (>= balance milestone)
                    (begin
                        (print { event: MILESTONE_ACHIEVED_EVENT, user: tx-sender, milestone: milestone })
                        (ok { status: "Achieved", milestone: milestone, balance: balance }))
                    (ok { status: "In Progress", milestone: milestone, balance: balance })))
            (err "Savings record not found"))))
