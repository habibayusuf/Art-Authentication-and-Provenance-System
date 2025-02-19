;; Provenance Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))

;; Data Variables
(define-data-var last-transfer-id uint u0)

;; Data Maps
(define-map ownership-history
  { artwork-id: uint, transfer-id: uint }
  {
    from: (optional principal),
    to: principal,
    timestamp: uint
  }
)

;; Public Functions

;; Record ownership transfer
(define-public (record-transfer (artwork-id uint) (from (optional principal)) (to principal))
  (let
    (
      (transfer-id (+ (var-get last-transfer-id) u1))
    )
    (map-set ownership-history
      { artwork-id: artwork-id, transfer-id: transfer-id }
      {
        from: from,
        to: to,
        timestamp: block-height
      }
    )
    (var-set last-transfer-id transfer-id)
    (ok transfer-id)
  )
)

;; Read-only Functions

;; Get the latest transfer for an artwork
(define-read-only (get-latest-transfer (artwork-id uint))
  (let
    (
      (transfer-id (var-get last-transfer-id))
    )
    (ok (map-get? ownership-history { artwork-id: artwork-id, transfer-id: transfer-id }))
  )
)

;; Initialize contract
(begin
  (var-set last-transfer-id u0)
)

