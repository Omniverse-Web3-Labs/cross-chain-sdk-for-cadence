import Cocomputation from "../contracts/Cocomputation.cdc"

transaction () {

    prepare(acct: AuthAccount) {
        if let requester <- acct.load<@Cocomputation.Requester>(from: /storage/requester) {
            destroy requester;
        }

        if let server <- acct.load<@Cocomputation.ComputationServer>(from: /storage/computationServer) {
            destroy server;
        }
    }

    execute {
        
    }
}