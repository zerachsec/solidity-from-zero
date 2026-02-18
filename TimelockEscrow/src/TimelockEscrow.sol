// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract TimelockEscrow {
    address public seller;

    uint256 private constant LOCK_TIME = 3 days;

    struct Escrow {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Escrow) private escrows;

    constructor() {
        seller = msg.sender;
    }

    /**
     * creates a buy order between msg.sender and seller
     * escrows msg.value for 3 days which buyer can withdraw anytime before 3 days
     * should revert if an active escrow still exists
     */
    function createBuyOrder() external payable {
        require(msg.value > 0, "No ETH sent");

        Escrow storage e = escrows[msg.sender];

        // active escrow must be cleared first
        require(e.amount == 0, "Active escrow exists");

        escrows[msg.sender] = Escrow({amount: msg.value, startTime: block.timestamp});
    }

    /**
     * allows seller to withdraw after 3 days of the escrow for a given buyer
     */
    function sellerWithdraw(address buyer) external {
        require(msg.sender == seller, "Not seller");

        Escrow storage e = escrows[buyer];
        require(e.amount > 0, "No escrow");
        require(block.timestamp >= e.startTime + LOCK_TIME, "Still locked");

        uint256 amount = e.amount;
        delete escrows[buyer];

        (bool ok,) = seller.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    /**
     * allows buyer to withdraw anytime before 3 days
     */
    function buyerWithdraw() external {
        Escrow storage e = escrows[msg.sender];
        require(e.amount > 0, "No escrow");
        require(block.timestamp < e.startTime + LOCK_TIME, "Lock expired");

        uint256 amount = e.amount;
        delete escrows[msg.sender];

        (bool ok,) = msg.sender.call{value: amount}("");
        require(ok, "Transfer failed");
    }

    /// returns escrowed amount of a buyer
    function buyerDeposit(address buyer) external view returns (uint256) {
        return escrows[buyer].amount;
    }
}
