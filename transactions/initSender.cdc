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
        let sendVault <- SentMessageContract.createSentMessageVault();
        acct.save(<- sendVault, to: /storage/sentMessageVault);
        acct.unlink(/public/sentMessageVault);
        acct.link<&{SentMessageContract.SentMessageInterface, SentMessageContract.AcceptorFace}>(/public/sentMessageVault, target: /storage/sentMessageVault);

        CrossChain.registerSendAccount(address: acct.address, link: "sentMessageVault");
    }

    execute {
        
    }
}