pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template hashPair(p1, p2){
    signal output out;
    var hash = p1 + p2;
    out <== hash;
}

template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
    component blocks[n+1];
    var hash;
    var i = 0;

    while(i < n){
        blocks[i] = hashPair(leaves[i], leaves[i+1]);
        i += 2;
    }

    for(var i = 0; i < blocks.length; i++){
        hash += blocks[i][1] + blocks[i][2];
    }

    root <== hash;


}

template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
}