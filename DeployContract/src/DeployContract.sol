// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract Deployer {
    /*
        This exercise assumes you know how to deploy a contract.

        1. Deploy `DeployMe` contract and return the address in `deployContract` function.
    */

    function deployContract() public returns (address) {
        // your code here
        DeployMe deployMe = new DeployMe();
        return address(deployMe);
    }
}

contract DeployMe {
    /*
        This is the contract you need to deploy in the `deployContract` function of `Deployer` contract.
    */

    function getMessage() external pure returns (string memory) {
        return "Hello, I'm deployed!";
    }
}
