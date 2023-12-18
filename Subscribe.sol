// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SubscriptionPayment is Ownable {
    IERC20 public token;  // Use OpenZeppelin's ERC-20 interface

    mapping(address => bool) public subscribers;
    uint256 public subscriptionFee;

    event SubscriptionPaid(address indexed subscriber);
    event LogMessage(address indexed sender, string message);

    modifier onlySubscribers() {
        require(subscribers[msg.sender], "Only subscribers can call this function");
        _;
    }

   constructor(address _tokenAddress, address initialOwner) Ownable(initialOwner) {
        token = IERC20(_tokenAddress);
        subscriptionFee = 100000000;
    }

    function subscribe() external {
        require(!subscribers[msg.sender], "Already subscribed");
        emit LogMessage(msg.sender, "Sender Addr!");
        emit LogMessage(address(this), "This Addr!");
        // Approve the contract to spend the subscription fee on behalf of the subscriber
        token.approve(msg.sender,subscriptionFee);

        // Transfer tokens from the subscriber to this contract
        //token.transferFrom(_userAddress, address(this), subscriptionFee);
        token.transfer(address(this), subscriptionFee);

        subscribers[msg.sender] = true;
        emit SubscriptionPaid(msg.sender);
    }

    function getAllowance(address tokenHolder) external view returns (uint256) {
    return token.allowance(tokenHolder, address(this));
    }

    function withdrawFunds() external onlyOwner {
        // Only the owner can withdraw tokens from the contract
        token.transfer(owner(), token.balanceOf(address(this)));
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    // Function to deposit tokens to the contract
    function depositTokens(uint256 amount) external onlyOwner {
        token.transferFrom(owner(), address(this), amount);
    }
}
