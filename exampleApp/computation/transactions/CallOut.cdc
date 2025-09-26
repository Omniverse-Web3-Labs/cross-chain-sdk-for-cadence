import Cocomputation from "../contracts/Cocomputation.cdc"

transaction (toChain: String, 
            contractName: String, 
            actionName: [UInt8], 
            inputs: [UInt32]) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Cocomputation.testCallOut(toChain: toChain, 
                                    contractName: contractName.decodeHex(), 
                                    actionName: actionName, 
                                    numbers: inputs);
    }
}
 