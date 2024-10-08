# Advanced Token Sale Smart Contract

This smart contract implements an advanced token sale mechanism where users can buy tokens, subject to purchase limits, and the owner has full control over the token price, contract funds, and contract termination. It also includes robust error handling using Solidity's `require()`, `revert()`, and `assert()` functions.

## Features

- **Token Sale**: Users can purchase tokens as long as they send enough Ether and do not exceed the maximum purchase limit.
- **Ownership Control**: The contract owner can mint tokens, set token prices, withdraw funds, and terminate the contract.
- **Dynamic Pricing**: The owner can update the price per token anytime.
- **Contract Termination**: The owner can terminate the contract once all tokens are sold, transferring remaining Ether to their account.
- **Error Handling**: The contract employs `require()` to enforce conditions like token availability and Ether sufficiency, `revert()` to stop execution if unsold tokens remain during contract termination, and `assert()` to check for contract invariants like balance consistency.

## Installation

1. Install dependencies using `npm install`.
2. Compile the contract using Hardhat with `npx hardhat compile`.
3. Deploy the contract via Hardhat or Remix.

## Interaction

- **Buy Tokens**: Users can buy tokens by sending Ether, with a limit on how many can be bought in one transaction.
- **Withdraw Funds**: Only the contract owner can withdraw Ether accumulated from token sales.
- **Set Token Price**: The owner can update the price per token.
- **Terminate Contract**: The contract can only be terminated when all tokens are sold, ensuring proper closure.

## Security

- **Access Control**: Only the contract owner can withdraw funds, change token prices, and terminate the contract.
- **Invariants**: The contract checks token availability, Ether sufficiency, and total balance consistency before key actions.
- **Safe Termination**: Ensures that the contract cannot be closed prematurely if tokens remain unsold.

## License

This contract is open-sourced under the MIT License.
