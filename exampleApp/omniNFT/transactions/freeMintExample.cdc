/*
import ExampleNFT from 0xf8d6e0586b0a20c7;
import StarRealm from 0xf8d6e0586b0a20c7;
import MetadataViews from 0xf8d6e0586b0a20c7;
import NonFungibleToken from 0xf8d6e0586b0a20c7;
import StarLocker from 0xf8d6e0586b0a20c7;
*/

///*
import ExampleNFT from 0x5f37faed5f558aca;
import StarRealm from 0x5f37faed5f558aca;
import MetadataViews from 0x5f37faed5f558aca;
import NonFungibleToken from 0x5f37faed5f558aca;
import StarLocker from 0x5f37faed5f558aca;
//*/

transaction (description: String) {

    prepare(acct: AuthAccount) {
        let recipientRef = ExampleNFT.getCollectionPublic(addr: acct.address);

        ExampleNFT.mintNFT(
                recipient: recipientRef,
                description: description,
                thumbnail: "http://47.241.69.26:8080/ipfs/QmcqdLbESiDbYP8BVrL95rHArM3CxAaWg7fLFZ28SBAphR#/",
                royalties: []                       
        );
    }

    execute {
        
    }
}
