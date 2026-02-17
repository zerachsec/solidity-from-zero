// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract OneWeekLockup {
    /**
     * In this exercise you are expected to create functions that let users deposit ether
     * Users can also withdraw their ether (not more than their deposit) but should only be able to do a week after their last deposit
     * Consider edge cases by which users might utilize to deposit ether
     *
     * Required function
     * - depositEther()
     * - withdrawEther(uint256 )
     * - balanceOf(address )
     */
    function balanceOf(address user) public view returns (uint256) {
        // return the user's balance in the contract
        return userBalances[user];
    }

    mapping(address => uint256) public userBalances;
    mapping(address => uint256) public lastDepositTime;

    function depositEther() external payable {
        /// add code here
        userBalances[msg.sender] += msg.value;
        lastDepositTime[msg.sender] = block.timestamp;
    }

    function withdrawEther(uint256 amount) external {
        /// add code here
        require(userBalances[msg.sender] >= amount, "Insufficient balance");
        require(
            block.timestamp >= lastDepositTime[msg.sender] + 1 weeks,
            "You can only withdraw after a week from your last deposit"
        );
        userBalances[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
