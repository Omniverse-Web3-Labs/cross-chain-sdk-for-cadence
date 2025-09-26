import ExampleNFT from 0x5f37faed5f558aca;

pub fun main(addr: Address): [UInt64] {
    let collectionRef = ExampleNFT.getExamplePubblic(addr: addr);

    return collectionRef.getIDs();
}