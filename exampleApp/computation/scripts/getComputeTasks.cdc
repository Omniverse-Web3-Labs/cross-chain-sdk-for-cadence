import Cocomputation from "../contracts/Cocomputation.cdc"

pub fun main(addr: Address): [[UInt32]] {
    let acct = getAuthAccount(addr);
    let serverRef = acct.borrow<&Cocomputation.ComputationServer>(from: /storage/computationServer)!;
    return serverRef.tasks;
}