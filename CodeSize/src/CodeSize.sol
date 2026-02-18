// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

contract CodeSize {
    /**
     * The challenge is to create a contract whose runtime code (bytecode) size is greater than 1kb but less than 4kb
     */
    bytes32[64] private data;

    constructor() {
        for (uint256 i = 0; i < data.length; i++) {
            data[i] = keccak256(abi.encodePacked(i));
        }
    }

    function getData(uint256 index) external view returns (bytes32) {
        require(index < data.length, "Out of bounds");
        return data[index];
    }

    function sumHashes() external view returns (bytes32 result) {
        for (uint256 i = 0; i < data.length; i++) {
            result = keccak256(abi.encodePacked(result, data[i]));
        }
    }
}
