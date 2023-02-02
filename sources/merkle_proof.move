module merkle_proof::proof{
    use std::vector;
    // use std::signer;
        // use std::string::{Self};
    use aptos_std::from_bcs;
    use std::bcs;
    use aptos_std::aptos_hash;
    // native public fun keccak256(bytes: vector<u8>): vector<u8>;
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
                computedHash = from_bcs::to_u8(aptos_hash::keccak256(computedHashVec1))
            }
            else{
                vector::push_back(&mut computedHashVec2,proofElement);
                computedHash = from_bcs::to_u8(aptos_hash::keccak256(computedHashVec2))
            };
            i = i+1
        };
        computedHash == root
    }
    #[test(leaf_address = @0x1111111111111111111111111111111111111111)]
    fun test_merkle(leaf_address:address):bool{
        let root = b"0xd4dee0beab2d53f2cc83e567171bd2820e49898130a22622b10ead383e90bd77";
        let proof = b"0xb92c48e9d7abe27fd8dfd6b5dfdbfb1c9a463f80c712b66f3a5180a090cccafc";
        // let leafHashVec1 = vector::empty<u8>();
        let addressu8 = bcs::to_bytes(&leaf_address);
        // let addr_vec = b"0x1111111111111111111111111111111111111111";
        // vector::push_back(&mut leafHashVec1,addr_vec);
        // vector::push_back(&mut leafHashVec1,addressu8);
        vector::push_back(&mut addressu8,100);
        let leaf = from_bcs::to_u8(aptos_hash::keccak256(addressu8));
        verify(proof,from_bcs::to_u8(root),leaf)
    }
}