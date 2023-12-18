// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract BNBSender {
    address public sender;
    address public recipient;
    uint256 public amount;

    constructor(address _recipient, uint256 _amount) {
        sender = msg.sender;
        recipient = _recipient;
        amount = _amount;
    }

    function send() external returns (bool) {
        IERC20 BNB = IERC20(0xB8c77482e45F1F44dE1745F52C74426C631bDD52);
        BNB.transferFrom(sender, recipient, amount);
        return true;
    }
}
