// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract HoneypotERC20 is ERC20 {
    event HoneypotTriggered(
        address indexed attacker,
        string action,
        address indexed target,
        uint256 amount,
        uint256 timestamp
    );

    constructor() ERC20("GhostNet Honeypot Token", "GHP") {
        // Mint a large supply to the deployer (honeypot bait)
        _mint(msg.sender, 1_000_000 * 1e18);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        emit HoneypotTriggered(msg.sender, "transfer", to, amount, block.timestamp);
        return super.transfer(to, amount);
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        emit HoneypotTriggered(msg.sender, "approve", spender, amount, block.timestamp);
        return super.approve(spender, amount);
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        emit HoneypotTriggered(msg.sender, "transferFrom", to, amount, block.timestamp);
        return super.transferFrom(from, to, amount);
    }

    // You can add more fake-vulnerable functions here to attract attackers
    // For example, a function that looks like it allows anyone to withdraw tokens

    function withdrawAll() external {
        // Looks like a vulnerability, but doesn't actually transfer tokens
        emit HoneypotTriggered(msg.sender, "withdrawAll_attempt", address(this), balanceOf(address(this)), block.timestamp);
        // No actual withdrawal logic
    }
}