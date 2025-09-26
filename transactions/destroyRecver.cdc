/*
import ReceivedMessageContract from 0xf8d6e0586b0a20c7;
import CrossChain from 0xf8d6e0586b0a20c7;
*/

import ReceivedMessageContract from 0x5f37faed5f558aca;
import CrossChain from 0x5f37faed5f558aca;

transaction () {

    prepare(acct: AuthAccount) {

        if let recverRef = acct.borrow<&ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault) {
            recverRef.setOffline();
            CrossChain.removeRecvAccount(address: acct.address, link: "receivedMessageVault");
        }

        if let recverValt <- acct.load<@ReceivedMessageContract.ReceivedMessageVault>(from: /storage/receivedMessageVault) {
            acct.unlink(/public/receivedMessageVault);
            destroy recverValt;
        }
    }

    execute {
        
    }
}