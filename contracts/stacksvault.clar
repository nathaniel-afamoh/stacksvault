;; Title: StacksVault Protocol
;; Summary: A decentralized Bitcoin-collateralized stablecoin system built on Stacks
;; Description: StacksVault enables users to mint USD-pegged stablecoins (SVT) by locking Bitcoin as collateral.
;;              The protocol features over-collateralization, automated liquidations, and decentralized price oracles
;;              to maintain stability while preserving Bitcoin's value proposition on Stacks Layer 2.

;; Trait Definitions
(define-trait sip-010-token
  (
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 5) uint))
    (get-decimals () (response uint uint))
    (get-balance (principal) (response uint uint))
    (get-total-supply () (response uint uint))
  )
)

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INSUFFICIENT-BALANCE (err u1001))
(define-constant ERR-INVALID-COLLATERAL (err u1002))
(define-constant ERR-UNDERCOLLATERALIZED (err u1003))
(define-constant ERR-ORACLE-PRICE-UNAVAILABLE (err u1004))
(define-constant ERR-LIQUIDATION-FAILED (err u1005))
(define-constant ERR-MINT-LIMIT-EXCEEDED (err u1006))
(define-constant ERR-INVALID-PARAMETERS (err u1007))
(define-constant ERR-UNAUTHORIZED-VAULT-ACTION (err u1008))

;; Security Constants
(define-constant MAX-BTC-PRICE u1000000000000)  ;; Maximum reasonable BTC price
(define-constant MAX-TIMESTAMP u18446744073709551615)  ;; Maximum uint timestamp
(define-constant CONTRACT-OWNER tx-sender)

;; Protocol Configuration
(define-data-var stablecoin-name (string-ascii 32) "BitVault Protocol Token")
(define-data-var stablecoin-symbol (string-ascii 5) "BVP")
(define-data-var total-supply uint u0)
(define-data-var collateralization-ratio uint u150)
(define-data-var liquidation-threshold uint u125)

;; Protocol Parameters
(define-data-var mint-fee-bps uint u50)
(define-data-var redemption-fee-bps uint u50)
(define-data-var max-mint-limit uint u1000000)

;; Oracle System
(define-map btc-price-oracles principal bool)
(define-map last-btc-price 
  {
    timestamp: uint,
    price: uint
  }
  uint
)

;; Vault System
(define-map vaults 
  {
    owner: principal, 
    id: uint
  }
  {
    collateral-amount: uint,
    stablecoin-minted: uint,
    created-at: uint
  }
)

(define-data-var vault-counter uint u0)

;; Oracle Management Functions
(define-public (add-btc-price-oracle (oracle principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (asserts! (and 
      (not (is-eq oracle CONTRACT-OWNER)) 
      (not (is-eq oracle tx-sender))
    ) ERR-INVALID-PARAMETERS)
    (map-set btc-price-oracles oracle true)
    (ok true)
  )
)