//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract

contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root
    uint16 private levels;
    uint16 private size;

    constructor() public {
        // [assignment] initialize a Merkle tree of 8 with blank leaves
        levels = 3;
        size = 8;

        hashes = new uint256[](2 * size - 1);
        for(uint i = 0; i < size; i++){
            hashes[i] = 0;
        }

        getHash();
    }

    function getHash() private{
        for(uint i = 0; i < size - 1; i++){
            hashes[size + i] = PoseidonT3.poseidon([hashes[2*i], hashes[2*i+1]]);
        }
        root = hashes[hashes.length - 1];
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
        hashes[index] = hashedLeaf;
        uint256 start = 0;
        uint offset = index;
    
        for (uint i = 1; i < size; i *= 2) {
            uint currentIndex = start + offset;
            start += size / i;
            offset /= 2;

            hashes[start + offset] = currentIndex % 2 == 0
                ? PoseidonT3.poseidon([hashes[currentIndex], hashes[currentIndex + 1]])
                : PoseidonT3.poseidon([hashes[currentIndex - 1], hashes[currentIndex]]);
        }

        ++index;
        root = hashes[hashes.length - 1];
        return root;
    }


    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {

        // [assignment] verify an inclusion proof and check that the proof root matches current root
        return root == input[0];
        

    }
}
