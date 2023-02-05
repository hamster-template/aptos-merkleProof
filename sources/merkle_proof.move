module merkle_proof::proof{
    use std::vector;
    use aptos_std::aptos_hash;

    const BYTESLENGHTMISMATCH:u64 = 0;

    public fun verify(proof:vector<vector<u8>>,root:vector<u8>,leaf:vector<u8>):bool{
        let computedHash = leaf;
        //assert!(vector::length(&root)==32 && vector::length(&leaf)==32 ,BYTESLENGHTMISMATCH);
        let i = 0;
        while (i < vector::length(&proof)) {
            let proofElement=*vector::borrow_mut(&mut proof, i);
            if (compare_vector(& computedHash,& proofElement)==1) {
                vector::append(&mut computedHash,proofElement);
                computedHash = aptos_hash::keccak256(computedHash)
            }
            else{
                vector::append(&mut proofElement,computedHash);
                computedHash = aptos_hash::keccak256(proofElement)
            };
            i = i+1
        };
        computedHash == root
    }
    fun compare_vector(a:&vector<u8>,b:&vector<u8>):u8{
        let index = 0;
        while(index < vector::length(a)){
            if(*vector::borrow(a,index) > *vector::borrow(b,index)){
                return 0
            };
            if(*vector::borrow(a,index) < *vector::borrow(b,index)){
                return 1
            };
            index = index +1;
        };
        1
    }
   #[test]
    fun test_merkle():bool{
        let leaf1=  b"0xd4dee0beab2d53f2cc83e567171bd2820e49898130a22622b10ead383e90bd77";
        let leaf2 = b"0x5f16f4c7f149ac4f9510d9cf8cf384038ad348b3bcdc01915f95de12df9d1b02";
        let leaf3 = b"0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470";
        let leaf4 = b"0x0da6e343c6ae1c7615934b7a8150d3512a624666036c06a92a56bbdaa4099751";
        // finding out the root
        let root1 = find_root(leaf1,leaf2);
        let root2 = find_root(leaf3,leaf4);
        let final_root = find_root(root1,root2);
        //the proofs
        let proof = vector[leaf2,root2];
        //here
        verify(proof,final_root,leaf1)
    }
    #[test]
    fun find_root(leaf1:vector<u8>,leaf2:vector<u8>):vector<u8>{
        let root= vector<u8>[];
        if (compare_vector(& leaf1,& leaf2)==1) {
                vector::append(&mut root,leaf1);
                vector::append(&mut root,leaf2);
                root = aptos_hash::keccak256(root);
            }
            else{
                vector::append(&mut root,leaf2);
                vector::append(&mut root,leaf1);
                root = aptos_hash::keccak256(root);
            };
        root
    }
}