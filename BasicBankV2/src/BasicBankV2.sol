// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract BasicBankV2 {
    /// used to store the balance of users
    ///     USER    =>  BALANCE
    mapping(address => uint256) public balances;

    /// @notice deposit ether into the contract
    /// @dev it should work properly when called multiple times
    function addEther() external payable {
        // Update the user's balance with the deposited amount
        balances[msg.sender] += msg.value;
    }

    /// @notice used to withdraw ether from the contract
    /// @param amount of ether to remove. Cannot execeed balance i.e users cannot withdraw more than they deposited
    function removeEther(uint256 amount) external payable {
        // Check if the user has enough balance to withdraw
        require(balances[msg.sender] >= amount, "Insufficient balance");

        // Update the user's balance before transferring to prevent reentrancy attacks
        balances[msg.sender] -= amount;

        // Transfer the specified amount of ether to the user
        payable(msg.sender).transfer(amount);
    }
}
