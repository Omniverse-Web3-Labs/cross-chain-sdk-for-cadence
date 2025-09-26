# Crosschain SDK for Cadence
## Introduction
This is the SDK with which developers can easily build their Omnichain dApps based on Omni Cross-chain Protocol on Flow. It's a little bit different from SDKs in other technology stack, the `flow-sdk` are quite convenient and even if with the `low-level-api` developers only need to create their own [Submitter](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/SentMessageContract.cdc#L41) and [SentMessageVault](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/SentMessageContract.cdc#L185) resources to make smart contracts invocation and send messages out to other chains. Similarly, they only need to create their own [ReceivedMessageVault](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/ReceivedMessageContract.cdc#L195) to receive resouce calls and messages from other chains.  
More details can be seen at [High-Level-API](#high-level-api) and [Low-Level-API](#low-level-api), and we provide two typical examples at [examples](#examples);

## Index
* [Environment](#environment)
* [High-Level API](#high-level-api)
* [Basic Tools](#basic-tools)
* [Low-Level API](#low-level-api)
* [Omnichain NFT](#omnichain-nft)
* [Examples](#examples)

## Environment
### Deployment
#### Testnet
* Officially, we have deployed the Protocol Stack at `0x5f37faed5f558aca` including the [Omni Cross-chain Protocol](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence) and [Omnichain NFT Infrastructure](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/tree/main/omniverseNFT).  
* We also deploy the Protocol Stack at `0x2999fe13d3CAa63C0bC523E8D5b19A265637dbd2` on Rinkeby for dev-test. If you want to build your own Omnichain smart contracts on Rinkeby, you can see more details at [solidity sdk tutorial](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-evm).
* As Opensea does not supprot Rinkeby currently, we also deployed the Protocol Stack at `0xf61C4699B99d1988EB235AF06F270029D9Ed3b63` on PlatON, and use [NFTScan](https://platon.nftscan.com/) instead. 

**Note that the `testnet-account` in [flow.json](./flow.json) is just for dev-testing, which may have already been used. So remember to create your own account to make operation on Testnet. You can follow this [tutorial](https://developers.flow.com/tools/flow-cli/create-accounts) to create a new account on Testnet and fund faucet [here](https://testnet-faucet.onflow.org/fund-account)** 

#### Emulator
As an Omnichain infrastructure, it's necessary to cooperate with other chains and in order to test in the local environment, there needs a simulator. Currently, the simulator is under developing. So we recommend you to choose the Testnet version to develop your dApps.

## High-Level API
The high-level api provides a very convenient way to create `resources`. When the contract [SDKUtility](./contracts/SDKUtility.cdc) is deployed with your own account, all omnichain resources including `ReceivedMessageVault`, `SentMessageVault`, and `Submitter` are created, saved and registered by the constructor. More over, `SDKUtility` provides some methods with `access(account)` to help developers implement cross-chain operations. The `access(account)` means only the deployed account related smart contracts and resources has the permission to call these methods.  
* [callOut](./contracts/SDKUtility.cdc#L30): help developers send an invocation out with a callback to receive results. The parameter `callback` is a string to build a `PublicPath`, which is transformed to `utf8` to be the input. And the `callback` is related to the interface `ReceivedMessageContract.Callee` of resources that is neccessary to receive messages from outside. In addition, although the `callOut` and `callback` heppen in different blocks, which is asynchronous of course, they could still be "connected" by [Session](./exampleApp/computation/contracts/Cocomputation.cdc#L53) in [Context](./exampleApp/computation/contracts/Cocomputation.cdc#L50).  
* [sendOut](./contracts/SDKUtility.cdc#L49): help developers send a common message out without a callback. An example can be found at [ComputationServer](./exampleApp/computation/contracts/Cocomputation.cdc#L88).  

Both `callOut` and `sendOut` return a [ContextKeeper.Context](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/ContextKeeper.cdc#L5), which contains a [Session](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/MessageProtocol.cdc#L319) with a `Session.id` inside that might be neccessary when processing the `callback`. The [Requester](./exampleApp/computation/contracts/Cocomputation.cdc#L47) example descripes an use case about how a `Session` can help connect context between `callOut` and `callback`(interface `ReceivedMessageInterface.Callee`).   

The two above methods in `SDKUtility` are responsible for sending invocations or messages out, and we still need methods to receive messages. In resource-oriented programming we need to bind receiving to every concrete resource, that is, every resource who wants to receive outside invocations or messages needs to implement the interface [ReceivedMessageInterface.Callee](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/ReceivedMessageContract.cdc#L20). Examples can be fount both at [Greetings](./exampleApp/greetings/contracts/Greetings.cdc) and [Cocomputation](./exampleApp/computation/contracts/Cocomputation.cdc).  

Generally, the example [Cocomputation](./exampleApp/computation/) is a typical use case of the high-level api.  

## Basic Tools
Note that remember to switch the import address when swiching between `emulator` and `testnet`.

To use the Omnichain functions of Omni Cross-chain Protocol, there needs to be a `ReceivedMessageVault` resource and a `SentMessageVault` resource. We have deployed a **global** resource at `0x5f37faed5f558aca`, with public link `sentMessageVault` and `receivedMessageVault`.  

To use your own `ReceivedMessageVault` and `SentMessageVault` to be more secure, try the following tools. Example of the [Flow CLI](https://developers.flow.com/tools/flow-cli) can be found in [opsh](./opsh);

### Transactions
* [initSender](./transactions/initSender.cdc) creates account bound `SentMessageVault` and registered to `CrossChain`
* [initRecver](./transactions/initRecver.cdc) creates account bound `ReceivedMessageVault` and registered to `CrossChain`
* [destroySender](./transactions/destroySender.cdc) clear the related resource
* [destroyRecver](./transactions/destroyRecver.cdc) clear the related resource
* [transferFlow](./transactions/transferFlow.cdc) Flow token transferring tool

### Scripts
* [checkRegistered](./scripts/checkRegistered.cdc) check the registered `ReceivedMessageVault`s and `SentMessageVault`s.   

## Low-Level API
### Message Protocol
The public sections of Omnichain messages related to dApp development are defined in [MessageProtocol](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/MessageProtocol.cdc), including:
* [MessagePayload](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/MessageProtocol.cdc#L224) expresses user difined content used for interaction with other smart contracts deployed on other chains. `MessagePayload` is composed of [MessageItem](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/MessageProtocol.cdc#L99)s, which is compatible with all the different technology stack and supports all of the build-in types of different chains. The usage of how to construct a `MessagePayload` can be seen [here](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/omniverseNFT/contracts/StarLocker.cdc#L297).
* [SQoS](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/MessageProtocol.cdc#L295) is used for setting the demand of security quality of services for dApps to make a balance between security and scalability. If the user does not set SQoS explicitly, the underlying will work defaultly.
* [Seesion](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/MessageProtocol.cdc#L319) is maintained by the underlying and users only need to set callback and commitment/answer if neccessary.  

### Receive/Called From
#### ReceivedMessageVault
* Creation and Destroying
```sh
# create account bound `ReceivedMessageVault`
flow transactions send ./transactions/initRecver.cdc --signer <your account> -n testnet

# clear the `ReceivedMessageVault` resource
flow transactions send ./transactions/destroyRecver.cdc --signer <your account> -n testnet
```

* [Callee Interface](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/ReceivedMessageContract.cdc#L20) provides a public interface for user-defined resources to receive invocations outside, the usage of which can be seen in [examples](./exampleApp/greetings/contracts/Greetings.cdc#L17).

* (*Can be ignored by smart contract builders*)The [Public Interface](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/ReceivedMessageContract.cdc#L9) of `ReceivedMessageVault` mainly includes `getNextMessageID` and `submitRecvMessage`, both of which is for off-chain routers.

### Send/Call Out
#### SentMessageVault
* Creation and Destroying
```sh
# create account bound `SentMessageVault`
flow transactions send ./transactions/initSender.cdc --signer <your account> -n testnet

# clear the `SentMessageVault` resource
flow transactions send ./transactions/destroySender.cdc --signer <your account> -n testnet
```
* (*Can be ignored by smart contract builders*)The [Public Interface](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/SentMessageContract.cdc#L168) of `SentMessageVault` mainly includes `getAllMessages()` and `getMessageById(messageId: UInt128)`, both of which is for off-chain routers.

#### Submitter
* Creation and Destroying
```sh
cd exampleApp/greetings

# create account bound `Submitter`
flow transactions send ./transactions/initSubmitter.cdc --signer <your account> -n testnet

# clear the `Submitter` resource
flow transactions send ./transactions/destroySubmitter.cdc --signer <your account> -n testnet

```

* The [Resource Interface](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/SentMessageContract.cdc#L54) of `Submitter` is `submitWithAuth`, which is responsible for submit messages or invocations out. The usage of `submitWithAuth` can be seen in [example](./exampleApp/greetings/contracts/Greetings.cdc#L58):
    * @param `outContent`: Struct [msgToSubmit](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/contracts/SentMessageContract.cdc#L9)
    * @param `acceptorAddr`: The owner address of the `SentMessageVault` resource, which can be the global one or created by yourself.
    * @param `alink`: the public link of the `SentMessageVault` resource, which is default to be *sentMessageVault*
    * @param `oSubmitterAddr`: The owner address of the `Submitter`
    * @param `slink`: the `Submitter`'s public link, which is default to be *msgSubmitter*

## Omniverse NFT
You can find detailed introduction of `Omniverse NFT` [here](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/omniverseNFT).  

The usage of the Omnichain NFT Infrastructure is quite convenient, and the details are as follows:  
### Send NFT Out
* [StarLocker.sendoutNFT(...)](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/omniverseNFT/contracts/StarLocker.cdc#L254): Send an NFT from Flow to outside chains:
    * @param `transferToken`: An NFT implements the interface `NonFungibleToken.INFT` on Flow
    * @param `toChain`: The [target chain name]()
    * @param `contractName`: The `StarLocker` contract address on the target chain. *This will be optimized in the future*
    * @param `actionName`: The `function selector` receiving the NFTs from outside of the `StarLocker` on the target chain. *This will be optimized in the future*
    * @param `receiver`: The reciever(owner of the NFT) address on the target chain.
    * @param `hashValue`: The hash question to claim the NFT on the target chain.   
The use case can be seen [here](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/omniverseNFT/scripts/SendNFToutTest.cdc#L159)

### Claim NFT Coming in
* [StarLocker.claimNFT(...)](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/omniverseNFT/contracts/StarLocker.cdc#L318): Claim an NFT back to Flow account when receiving an NFT outside.
   * @param: `domain: String`: the NFT name in the `DisplayView`
   * @param: `id: UInt64`: the NFT id
   * @param: `answer: String`, the hash answer to claim the NFT
The use case can be seen [here](https://github.com/Omniverse-Web3-Labs/crosschain-portal-for-cadence/blob/main/omniverseNFT/scripts/SendNFToutTest.cdc#L239)