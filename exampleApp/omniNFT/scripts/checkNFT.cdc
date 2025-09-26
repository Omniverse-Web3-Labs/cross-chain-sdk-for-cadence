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

pub fun main(addr: Address): [MetadataViews.Display] {
    let displayViews: [MetadataViews.Display] = [];

    let acctAuth = getAuthAccount(addr);

    let colloctionRef = acctAuth.borrow<&ExampleNFT.Collection>(from: ExampleNFT.CollectionStoragePath)!;

    let ids = colloctionRef.getIDs();

    for ele in ids {
        let nftRef = colloctionRef.borrowViewResolver(id: ele);
        displayViews.append(nftRef.resolveView(Type<MetadataViews.Display>())! as! MetadataViews.Display );
    }

    return displayViews;
}