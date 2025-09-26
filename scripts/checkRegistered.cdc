//import CrossChain from 0xf8d6e0586b0a20c7;
import CrossChain from 0x5f37faed5f558aca;

pub fun main(): [[Address]]{
    log(CrossChain.queryRegisteredRecvAccount());
    log(CrossChain.queryRegisteredSendAccount());

    return [CrossChain.queryRegisteredRecvAccount(), CrossChain.queryRegisteredSendAccount()];
}
