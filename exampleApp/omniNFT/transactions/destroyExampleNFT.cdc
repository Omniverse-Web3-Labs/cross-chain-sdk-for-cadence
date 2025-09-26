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

transaction (nftID: UInt64) {

  prepare(acct: AuthAccount) {

    if let collection = acct.borrow<&ExampleNFT.Collection>(from: ExampleNFT.CollectionStoragePath) {
        let nft <- collection.withdraw(withdrawID: nftID);
        destroy nft;
    } else {
        panic("There's no `ExampleNFT.Collection` in this account!");
    }
  }

  execute {
    
  }
}