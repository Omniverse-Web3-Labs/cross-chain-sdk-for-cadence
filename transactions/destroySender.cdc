/*
import SentMessageContract from 0xf8d6e0586b0a20c7;
import CrossChain from 0xf8d6e0586b0a20c7;
*/
///*
import SentMessageContract from 0x5f37faed5f558aca;
import CrossChain from 0x5f37faed5f558aca;
//*/

transaction () {

    prepare(acct: AuthAccount) {

        if let senderRef = acct.borrow<&SentMessageContract.SentMessageVault>(from: /storage/sentMessageVault) {
            senderRef.setOffline();
            CrossChain.removeSendAccount(address: acct.address, link: "sentMessageVault");
        }

        if let senderValt <- acct.load<@SentMessageContract.SentMessageVault>(from: /storage/sentMessageVault) {
            acct.unlink(/public/sentMessageVault);
            destroy senderValt;
        }
    }

    execute {
        
    }
}