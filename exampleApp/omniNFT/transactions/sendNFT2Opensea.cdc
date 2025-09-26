/*
import ExampleNFT from 0xf8d6e0586b0a20c7;
import StarRealm from 0xf8d6e0586b0a20c7;
import MetadataViews from 0xf8d6e0586b0a20c7;
import NonFungibleToken from 0xf8d6e0586b0a20c7;
import StarLocker from 0xf8d6e0586b0a20c7;
import MessageProtocol from 0xf8d6e0586b0a20c7;
*/

///*
import ExampleNFT from 0x5f37faed5f558aca;
import StarRealm from 0x5f37faed5f558aca;
import MetadataViews from 0x5f37faed5f558aca;
import NonFungibleToken from 0x5f37faed5f558aca;
import StarLocker from 0x5f37faed5f558aca;
import MessageProtocol from 0x5f37faed5f558aca;
//*/

transaction(toChain: String, contractName: String, actionName: String, hashQuestion: String, recver: String, nftID: UInt64) {

    prepare(acct: AuthAccount) {
        let hashValue = HashAlgorithm.KECCAK_256.hash(hashQuestion.utf8);

        if let collection = acct.borrow<&ExampleNFT.Collection>(from: ExampleNFT.CollectionStoragePath) {
            let nft <- collection.withdraw(withdrawID: nftID);
            
            StarLocker.sendoutNFT(transferToken: <- nft, 
                                    toChain: toChain,
                                    contractName: contractName.decodeHex(),
                                    actionName: actionName.decodeHex(),
                                    receiver: MessageProtocol.CDCAddress(addr: recver.decodeHex(), t: 1), 
                                    hashValue: String.encodeHex(hashValue));

        } else {
            panic("There's no `ExampleNFT.Collection` in this account!");
        }
    }

    execute {
        
    }
}