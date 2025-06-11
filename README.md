# StacksVault Protocol

A decentralized Bitcoin-collateralized stablecoin system built on Stacks Layer 2, enabling users to mint USD-pegged stablecoins (SVT) by locking Bitcoin as collateral while preserving Bitcoin's value proposition.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [System Components](#system-components)
- [Data Flow](#data-flow)
- [Contract Features](#contract-features)
- [Security Measures](#security-measures)
- [Usage Guide](#usage-guide)
- [Governance](#governance)
- [Risk Management](#risk-management)

## Overview

StacksVault Protocol is a decentralized finance (DeFi) platform that allows users to:

- **Mint Stablecoins**: Create USD-pegged tokens (BitVault Protocol Token - BVP) using Bitcoin as collateral
- **Over-collateralization**: Maintain system stability through configurable collateralization ratios
- **Automated Liquidations**: Protect the protocol through risk management mechanisms
- **Decentralized Oracles**: Utilize multiple price feed sources for accurate Bitcoin pricing

### Key Metrics

- **Default Collateralization Ratio**: 150%
- **Liquidation Threshold**: 125%
- **Mint/Redemption Fees**: 0.50% (50 basis points)
- **Maximum Mint Limit**: 1,000,000 BVP tokens

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    StacksVault Protocol                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │   Oracle    │  │    Vault    │  │    Stablecoin       │ │
│  │   System    │  │  Management │  │    Management       │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐ │
│  │Risk Mgmt &  │  │ Governance  │  │   Security Layer    │ │
│  │Liquidations │  │   System    │  │                     │ │
│  └─────────────┘  └─────────────┘  └─────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                           │
                           ▼
                 ┌─────────────────┐
                 │  Stacks Layer 2 │
                 │   (Bitcoin L2)  │
                 └─────────────────┘
```

## System Components

### 1. Oracle System

- **Multi-Oracle Architecture**: Support for multiple authorized price feed providers
- **Price Validation**: Built-in bounds checking and timestamp validation
- **Real-time Updates**: Continuous Bitcoin price feeds for accurate collateralization calculations

### 2. Vault Management

- **Individual Vaults**: Each user can create multiple isolated vaults
- **Collateral Tracking**: Precise tracking of Bitcoin collateral per vault
- **Mint Tracking**: Monitor stablecoin issuance against each vault

### 3. Stablecoin Token (BVP)

- **SIP-010 Compliant**: Standard Stacks token interface implementation
- **Supply Management**: Dynamic total supply based on minting and redemption
- **Transfer Capabilities**: Full token transfer functionality

### 4. Risk Management

- **Automated Liquidations**: Trigger liquidations when vaults fall below threshold
- **Collateralization Monitoring**: Continuous assessment of vault health
- **Emergency Controls**: Protocol-level safeguards and limits

## Data Flow

```
1. Price Oracle Updates
   ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
   │   Oracle    │───▶│  Price Feed  │───▶│  Protocol State │
   │  Providers  │    │  Validation  │    │    Update       │
   └─────────────┘    └──────────────┘    └─────────────────┘

2. Vault Creation & Minting
   ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
   │    User     │───▶│   Create     │───▶│   Lock BTC &    │
   │   Request   │    │    Vault     │    │  Mint Tokens    │
   └─────────────┘    └──────────────┘    └─────────────────┘

3. Liquidation Process
   ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
   │ Collateral  │───▶│ Liquidation  │───▶│   Vault         │
   │   Check     │    │   Trigger    │    │  Liquidation    │
   └─────────────┘    └──────────────┘    └─────────────────┘

4. Redemption Flow
   ┌─────────────┐    ┌──────────────┐    ┌─────────────────┐
   │   Return    │───▶│    Burn      │───▶│   Release       │
   │ Stablecoins │    │   Tokens     │    │  Collateral     │
   └─────────────┘    └──────────────┘    └─────────────────┘
```

## Contract Features

### Core Functions

#### Vault Operations

- `create-vault`: Initialize a new collateralized vault
- `mint-stablecoin`: Issue stablecoins against vault collateral
- `redeem-stablecoin`: Return stablecoins to reclaim collateral
- `liquidate-vault`: Liquidate undercollateralized vaults

#### Oracle Management

- `add-btc-price-oracle`: Authorize new price feed providers
- `update-btc-price`: Submit Bitcoin price updates

#### Governance

- `update-collateralization-ratio`: Modify system collateral requirements

### Read-Only Functions

- `get-latest-btc-price`: Retrieve current Bitcoin price
- `get-vault-details`: Access vault information
- `get-total-supply`: Check total stablecoin supply

## Security Measures

### Input Validation

- **Price Bounds**: Maximum BTC price limits prevent oracle manipulation
- **Timestamp Validation**: Ensure price feed recency
- **Parameter Bounds**: Governance parameter ranges protection

### Access Control

- **Owner-Only Functions**: Critical operations restricted to contract owner
- **Vault Authorization**: Users can only operate their own vaults
- **Oracle Authorization**: Only approved oracles can submit prices

### Economic Security

- **Over-collateralization**: Required 150% collateral ratio
- **Liquidation Buffer**: 25% buffer between mint ratio and liquidation
- **Mint Limits**: Maximum issuance caps prevent excessive leverage

## Usage Guide

### For Users

1. **Create a Vault**

   ```clarity
   (create-vault collateral-amount)
   ```

2. **Mint Stablecoins**

   ```clarity
   (mint-stablecoin vault-owner vault-id mint-amount)
   ```

3. **Redeem Collateral**

   ```clarity
   (redeem-stablecoin vault-owner vault-id redeem-amount)
   ```

### For Liquidators

Monitor vault health and execute liquidations:

```clarity
(liquidate-vault vault-owner vault-id)
```

### For Oracles

Submit price updates:

```clarity
(update-btc-price price timestamp)
```

## Governance

The protocol includes governance mechanisms for:

- **Collateralization Ratio**: Adjustable between 100-300%
- **Oracle Management**: Addition of authorized price feed providers
- **Fee Structure**: Configurable mint and redemption fees
- **System Limits**: Maximum mint limits and other protocol parameters

## Risk Management

### Liquidation System

- **Threshold Monitoring**: Continuous vault health assessment
- **Incentivized Liquidations**: Public liquidation function with rewards
- **Collateral Recovery**: Automatic collateral redistribution

### Oracle Risk Mitigation

- **Multiple Sources**: Support for multiple price feed providers
- **Price Validation**: Built-in sanity checks and bounds
- **Timestamp Requirements**: Fresh price data requirements

### Protocol Limits

- **Maximum Exposure**: Per-vault and system-wide mint limits
- **Parameter Bounds**: Governance parameter change restrictions
- **Emergency Controls**: Owner intervention capabilities

## Error Codes

| Code | Description |
|------|-------------|
| 1000 | Not Authorized |
| 1001 | Insufficient Balance |
| 1002 | Invalid Collateral |
| 1003 | Undercollateralized |
| 1004 | Oracle Price Unavailable |
| 1005 | Liquidation Failed |
| 1006 | Mint Limit Exceeded |
| 1007 | Invalid Parameters |
| 1008 | Unauthorized Vault Action |

## Development Status

This protocol is designed for production deployment on Stacks Layer 2, providing Bitcoin-backed stablecoin functionality with robust risk management and governance mechanisms.
