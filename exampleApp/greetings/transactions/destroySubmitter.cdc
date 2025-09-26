//import SentMessageContract from 0xf8d6e0586b0a20c7;

import SentMessageContract from 0x5f37faed5f558aca;

transaction () {

    prepare(acct: AuthAccount) {
        if let submitter <- acct.load<@SentMessageContract.Submitter>(from: /storage/msgSubmitter) {
            acct.unlink(/public/msgSubmitter);
            destroy submitter;
        }
    }

    execute {
        
    }
}
