// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract DistributeV2 {
    constructor() payable {}

    function distributeEther(address[] memory addresses) public {
        uint256 count = addresses.length;
        require(count > 0, "No recipients");

        uint256 balance = address(this).balance;
        uint256 share = balance / count;

        require(share > 0, "Insufficient balance");

        for (uint256 i = 0; i < count; i++) {
            (bool success,) = payable(addresses[i]).call{value: share}("");

            // If transfer fails, skip and continue
            if (!success) {
                continue;
            }
        }
        // Any remainder stays in contract
    }
}
