// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FoodOrdering {
    
    struct FoodItem {
        string name;
        uint256 price;
    }

    struct Order {
        uint256 itemId;
        uint256 quantity;
        uint256 totalPrice;
        bool isActive;
    }

    FoodItem[] public menu;
    mapping(address => Order[]) public orders;
    mapping(address => uint256) public balances;
    address public owner;

    event FoodOrdered(address indexed user, string foodName, uint256 quantity, uint256 totalPrice);
    event OrderCanceled(address indexed user, string foodName, uint256 quantity, uint256 refundAmount);
    event BalanceDeposited(address indexed user, uint256 amount);
    
    constructor() {
        owner = msg.sender;
        
        menu.push(FoodItem("Burger", 2 ether));
        menu.push(FoodItem("Pizza", 3 ether));
        menu.push(FoodItem("Pasta", 2.5 ether));
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function depositFunds() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        balances[msg.sender] += msg.value;
        emit BalanceDeposited(msg.sender, msg.value);
    }

    function getMenuItem(uint256 itemId) public view returns (string memory name, uint256 price) {
        require(itemId < menu.length, "Invalid menu item ID.");
        FoodItem memory item = menu[itemId];
        return (item.name, item.price);
    }

    function orderFood(uint256 itemId, uint256 quantity) public {
        require(itemId < menu.length, "Food item does not exist.");
        require(quantity > 0, "Quantity must be greater than zero.");
        
        FoodItem memory item = menu[itemId];
        uint256 totalPrice = item.price * quantity;

        if (balances[msg.sender] < totalPrice) {
            revert("Insufficient balance to place the order.");
        }
        
        balances[msg.sender] -= totalPrice;
        
        orders[msg.sender].push(Order({
            itemId: itemId,
            quantity: quantity,
            totalPrice: totalPrice,
            isActive: true
        }));

        emit FoodOrdered(msg.sender, item.name, quantity, totalPrice);
    }

    function cancelOrder(uint256 orderId) public {
        require(orderId < orders[msg.sender].length, "Invalid order ID.");
        Order storage orderToCancel = orders[msg.sender][orderId];
        
        require(orderToCancel.isActive, "Order has already been canceled or fulfilled.");
        
        uint256 refundAmount = orderToCancel.totalPrice;

        // Reverting if refundAmount exceeds available balance
        if (balances[msg.sender] + refundAmount < refundAmount) {
            revert("Refund would cause an overflow.");
        }

        balances[msg.sender] += refundAmount;
        orderToCancel.isActive = false;

        FoodItem memory item = menu[orderToCancel.itemId];
        emit OrderCanceled(msg.sender, item.name, orderToCancel.quantity, refundAmount);

        assert(balances[msg.sender] > 0);
    }

    function withdrawBalance(uint256 amount) public {
        // Fixing the bug by replacing 10^18 with 1 ether (10**18)
        uint256 amountEth = amount * 1 ether;
        require(amountEth > 0, "Withdrawal amount must be greater than zero.");
        if (balances[msg.sender] < amountEth) {
            revert("Insufficient balance for withdrawal.");
        }
        
        balances[msg.sender] -= amountEth;
        payable(msg.sender).transfer(amountEth);
    }

    // Revert for emergency rollback of payments (if needed)
    function revertTransaction(uint256 amount) internal {
        require(balances[msg.sender] >= amount, "Insufficient balance to revert.");
        balances[msg.sender] += amount;  // Adding back the amount to the sender's balance
    }
}
