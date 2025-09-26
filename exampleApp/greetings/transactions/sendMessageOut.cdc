import Greetings from "../contracts/Greetings.cdc"

transaction (toChain: String, 
            contractName: String, 
            actionName: [UInt8],
            senderAddr: Address) {

    prepare(acct: AuthAccount) {
        
    }

    execute {
        Greetings.sendGreeting(toChain: toChain, 
                                contractName: contractName.decodeHex(), 
                                actionName: actionName,
                                greetingMessage: "Hello nika", 
                                senderAddr: senderAddr, 
                                link: "msgSubmitter");
    }
}
