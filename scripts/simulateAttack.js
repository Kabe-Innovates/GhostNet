// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HoneypotERC20 is ERC20, Ownable {
    constructor(uint256 initialSupply) ERC20("HoneypotToken", "HPT") {
        _mint(msg.sender, initialSupply);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        require(recipient != address(0), "Transfer to the zero address");

        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(balanceOf(sender) >= amount, "Insufficient balance");
        require(allowance(sender, msg.sender) >= amount, "Transfer amount exceeds allowance");
        require(recipient != address(0), "Transfer to the zero address");

        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, allowance(sender, msg.sender) - amount);
        return true;
    }
}