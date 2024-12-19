
---

# Decentralized Auction Smart Contract

This repository contains the Solidity implementation of a decentralized reverse auction smart contract. The contract enables drivers to create service auctions, allows maintenance providers to bid competitively, and ensures task completion verification through blockchain-based transparency and automation.

---

## Features

- **Reverse Auction Mechanism**: Drivers initiate auctions for services, and providers bid with decreasing prices.
- **Escrow Payments**: Bid amounts are securely held in escrow until task completion.
- **Reputation System**: Incentivizes honest participation through dynamic reputation scoring.
- **Oracle-Based Task Verification**: Ensures impartial task completion evaluation.

---

## Smart Contract Overview

The contract includes the following key functionalities:
1. **Auction Initialization**: Drivers create auctions by specifying service details, budget, and duration.
2. **Bid Placement**: Maintenance providers place bids, with the lowest bid winning.
3. **Auction Finalization**: The driver finalizes the auction after the bidding period ends.
4. **Task Verification and Payment**: Funds in escrow are released to the winning provider upon task completion confirmation.
5. **Refunds**: Non-winning bidders can withdraw their refunded bid amounts.

---

## Deployment and Testing on Remix

Follow these steps to deploy and test the smart contract on [Remix Ethereum IDE](https://remix.ethereum.org):

### Step 1: Open Remix IDE

1. Navigate to [Remix](https://remix.ethereum.org) in your browser.
2. Ensure that you are in the **Solidity** environment by selecting it from the left panel.

### Step 2: Import the Smart Contract

1. Click on the **File Explorer** icon in the left panel.
2. Create a new file (e.g., `ServiceReverseAuction.sol`) and copy-paste the code from this repository into the file.

### Step 3: Compile the Contract

1. Click on the **Solidity Compiler** icon in the left panel.
2. Select the compiler version `0.8.0` (or a compatible version as specified in the contract).
3. Click **Compile ServiceReverseAuction.sol** to ensure there are no errors.

### Step 4: Deploy the Contract

1. Click on the **Deploy & Run Transactions** icon in the left panel.
2. Set the environment to **Injected Web3** to connect to a blockchain network (e.g., MetaMask for testnets like Goerli or Mumbai).
3. In the "Deploy" section:
   - Provide the following arguments for the constructor:
     - `_serviceDetails`: A string describing the service (e.g., `"Car Maintenance"`).
     - `_maxCap`: The maximum budget in Wei (e.g., `1000000000000000000` for 1 Ether).
     - `_auctionDuration`: Duration of the auction in seconds (e.g., `600` for 10 minutes).
4. Click **Deploy** and confirm the transaction in your connected wallet.
5. **Important**: Use one address to deploy the smart contract (Driver) and simulate the maintenance providers interacting with the contract using **different addresses**. This can be done by switching accounts in MetaMask or using Remix’s account selector.

### Step 5: Interact with the Contract

After deployment, the contract's functions will appear in the "Deployed Contracts" section.

#### Driver's Actions
- **Finalize Auction**: Call `finalizeAuction()` after the bidding period ends.
- **Confirm Completion**: Call `confirmCompletion()` to release funds to the winning bidder.

#### Provider's Actions
- **Place Bid**: Call `placeBid(amountInRupees)` to submit a bid. Ensure you have enough collateral in your wallet.
- **Withdraw Refund**: If outbid, call `withdrawRefund()` to reclaim your refunded bid amount.

---

## Key Functions

### Auction Initialization

The constructor initializes the auction:
```solidity
constructor(string memory _serviceDetails, uint256 _maxCap, uint256 _auctionDuration)
```
- `_serviceDetails`: A string specifying the auction details.
- `_maxCap`: Maximum budget for the service in Wei.
- `_auctionDuration`: Duration of the auction in seconds.

### Bid Placement

Providers can place bids using:
```solidity
function placeBid(uint256 amountInRupees) external payable
```

### Auction Finalization

The driver finalizes the auction:
```solidity
function finalizeAuction() external
```

### Task Verification and Payment

The driver confirms task completion:
```solidity
function confirmCompletion() external payable
```

### Refund Withdrawals

Non-winning bidders can withdraw refunds:
```solidity
function withdrawRefund() external
```

---

## Example Deployment Parameters

- **Service Details**: `"Car Maintenance"`
- **Max Budget**: `1 Ether (1000000000000000000 Wei)`
- **Auction Duration**: `600 seconds (10 minutes)`

---

## Prerequisites

- **MetaMask Wallet**: Required for connecting Remix to a test network.
- **Test Ether**: Obtain test Ether from faucets for the desired network.
- **Remix IDE**: An online Solidity IDE for deploying smart contracts.

---
