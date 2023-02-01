module merkle_proof::proof{
    use std::vector;
    use aptos_std::from_bcs;
    native public fun keccak256(bytes: vector<u8>): vector<u8>;
    public fun verify(proof:vector<u8>,root:u8,leaf:u8):bool{
        let computedHash = leaf;
        let computedHashVec1 = vector::empty<u8>();
        vector::push_back(&mut computedHashVec1,leaf);
        let computedHashVec2 = vector::empty<u8>();
        vector::push_back(&mut computedHashVec2,leaf);
        let i = 0;
        while (i < vector::length(&proof)) {
            let proofElement=*vector::borrow_mut(&mut proof, i);
            if (computedHash <= proofElement) {
                vector::push_back(&mut computedHashVec1,proofElement);
                computedHash = from_bcs::to_u8(keccak256(computedHashVec1))
            }
            else{
                vector::push_back(&mut computedHashVec2,proofElement);
                computedHash = from_bcs::to_u8(keccak256(computedHashVec2))
            };
            i = i+1
        };
        computedHash == root
    }

}