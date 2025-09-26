import Greetings from "../contracts/Greetings.cdc"

pub fun main(): [String] {
    return Greetings.getRecvedGreetings();
}