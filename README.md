# Food Ordering Smart Contract

This smart contract implements a decentralized food ordering system where users can place orders, deposit funds, and cancel active orders. The owner can manage the menu and ensure proper contract operation. It includes robust error handling using Solidity's `require()`, `revert()`, and `assert()` functions.

## Features

- **Order Food**: Users can order food from a predefined menu, and the total price is deducted from their balance if they have sufficient funds.
- **Cancel Orders**: Users can cancel active orders and receive a refund.
- **Deposit and Withdraw Funds**: Users can deposit Ether to their account balance and withdraw their balance when needed.
- **Menu Management**: The owner can manage the food items and prices in the menu.
- **Error Handling**: The contract uses `require()` to enforce conditions like sufficient balance and valid orders, `revert()` to stop execution on failure conditions (e.g., insufficient funds), and `assert()` for balance consistency checks.

## Installation

1. Install dependencies using `npm install`.
2. Compile the contract using Hardhat with `npx hardhat compile`.
3. Deploy the contract via Hardhat or Remix.

## Interaction

- **Order Food**: Users select food items from the menu, specifying the quantity, and the total cost is deducted from their account.
- **Cancel Order**: Users can cancel an order to receive a refund for the full amount of the order.
- **Deposit Funds**: Users deposit Ether to their account to make purchases.
- **Withdraw Funds**: Users can withdraw their balance (in Ether) at any time.

## Security

- **Access Control**: Only the owner can modify the menu.
- **Invariants**: The contract checks for sufficient user balances and ensures refunds do not cause overflows or inconsistencies.
- **Error Handling**: Uses `revert()` and `assert()` to handle insufficient funds, invalid orders, and consistency in balance management.

## License

This contract is open-sourced under the MIT License.