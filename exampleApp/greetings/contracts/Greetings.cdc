/*
import SentMessageContract from 0xf8d6e0586b0a20c7;
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
*/

///*
import SentMessageContract from 0x5f37faed5f558aca;
import ReceivedMessageContract from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
//*/

pub contract Greetings {
    pub resource GreetingRecver: ReceivedMessageContract.Callee {
        pub let recvedGreetings: [String];

        init() {
            self.recvedGreetings = [];
        }
        
        pub fun callMe(data: MessageProtocol.MessagePayload) {
            var greetingMessage = "";
            for ele in data.items {
                if ele.type == MessageProtocol.MsgType.cdcVecString.rawValue {
                    for strinvalue in (ele.value as! [String]) {
                        greetingMessage = greetingMessage.concat(strinvalue).concat("-");
                    }
                } else {
                    panic("Invalid value, need a `[String]`");
                }
            }

            greetingMessage = greetingMessage.concat(self.recvedGreetings.length.toString());

            self.recvedGreetings.append(greetingMessage);
        }
    }

    init() {
        self.account.save(<- create GreetingRecver(), to: /storage/GreetingRecver);
        self.account.link<&{ReceivedMessageContract.Callee}>(/public/GreetingRecver, target: /storage/GreetingRecver)
    }
    
    pub fun sendGreeting(toChain: String, 
                        contractName: [UInt8], 
                        actionName: [UInt8], 
                        greetingMessage: String, 
                        senderAddr: Address, 
                        link: String) {
        let submitterRef = self.account.borrow<&SentMessageContract.Submitter>(from: /storage/msgSubmitter)!;

        // Message params
        let sqos = MessageProtocol.SQoS()
        let callType: UInt8 = 1
        let callback: [UInt8] = []
        let commitment: [UInt8] = []
        let answer: [UInt8] = []

        let data = MessageProtocol.MessagePayload()

        let messageVec: [String] = ["FLOWTEST", "Greeting", greetingMessage, getCurrentBlock().timestamp.toString()];
        
        let greeting = MessageProtocol.createMessageItem(name: "greeting", type: MessageProtocol.MsgType.cdcVecString, value: messageVec);
        data.addItem(item: greeting!);

        let msg = SentMessageContract.msgToSubmit(toChain: toChain, 
                                                    sqos: sqos, 
                                                    contractName: contractName, 
                                                    actionName: actionName, 
                                                    data: data, 
                                                    callType: callType, 
                                                    callback: callback, 
                                                    commitment: commitment, 
                                                    answer: answer);
        submitterRef.submitWithAuth(msg, 
                                    acceptorAddr: senderAddr, 
                                    alink: "sentMessageVault", 
                                    oSubmitterAddr: self.account.address, 
                                    slink: link);
    }

    pub fun getRecvedGreetings(): [String] {
        let recverRef = self.account.borrow<&GreetingRecver>(from: /storage/GreetingRecver)!;
        return recverRef.recvedGreetings;
    }
}
