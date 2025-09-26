pub fun main(): String {
    let srcStr = "GreetingRecver";
    let srcBytes = srcStr.utf8;
    return String.encodeHex(srcBytes);
}