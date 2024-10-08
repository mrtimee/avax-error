// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AdvancedTokenSale {
    address public owner;
    uint256 public totalSupply;
    uint256 public tokenPrice; // Price per token in wei
    uint256 public constant MAX_PURCHASE_LIMIT = 100; // Max tokens a user can purchase
    mapping(address => uint256) public balances;

    constructor(uint256 _initialSupply, uint256 _tokenPrice) {
        owner = msg.sender;
        totalSupply = _initialSupply;
        tokenPrice = _tokenPrice;
        balances[owner] = _initialSupply; // All initial tokens belong to the owner
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    // Function to buy tokens
    function buyTokens(uint256 _amount) public payable {
        // Require: Check the amount is not exceeding the maximum purchase limit
        require(_amount <= MAX_PURCHASE_LIMIT, "Cannot buy more than the limit");
        
        uint256 cost = _amount * tokenPrice;
        require(msg.value >= cost, "Insufficient ether sent");

        require(balances[owner] >= _amount, "Not enough tokens available for sale");

        // Transfer tokens to the buyer
        balances[owner] -= _amount;
        balances[msg.sender] += _amount;
    }

    function withdrawFunds() public onlyOwner {
        // Assert: Ensure there's balance to withdraw
        uint256 contractBalance = address(this).balance;
        assert(contractBalance > 0);

        // Transfer contract balance to the owner
        payable(owner).transfer(contractBalance);
    }

    // Owner-only function to change the price of the token
    function setTokenPrice(uint256 _newPrice) public onlyOwner {
        require(_newPrice > 0, "Price must be greater than zero");

        tokenPrice = _newPrice;
    }

    function terminateContract() public onlyOwner {
        // Ensure all tokens are sold out before termination
        if (balances[owner] > 0) {
            revert("Cannot terminate contract until all tokens are sold");
        }

        assert(balances[owner] == 0);

        // Self-destruct and send remaining funds to the owner
        selfdestruct(payable(owner));
    }

    // Safety check using assert to ensure balance consistency
    function checkInvariant() public view {
        // Assert that the total supply equals the sum of all user balances
        uint256 totalBalances = 0;
        totalBalances += balances[owner] + balances[msg.sender];

        assert(totalBalances == totalSupply); 
    }
}
