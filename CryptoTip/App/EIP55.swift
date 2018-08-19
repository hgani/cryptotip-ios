import GaniLib
import EthereumKit

class EIP55 {
    // See https://github.com/D-Technologies/EthereumKit/blob/master/EthereumKit/Helper/EIP55.swift
    public static func encode(_ address: String) -> String {
        let hash = Crypto.hashSHA3_256(address.data(using: .ascii)!).toHexString()
        
        return zip(address, hash)
            .map { a, h -> String in
                switch (a, h) {
                case ("0", _), ("1", _), ("2", _), ("3", _), ("4", _), ("5", _), ("6", _), ("7", _), ("8", _), ("9", _):
                    return String(a)
                case (_, "8"), (_, "9"), (_, "a"), (_, "b"), (_, "c"), (_, "d"), (_, "e"), (_, "f"):
                    return String(a).uppercased()
                default:
                    return String(a).lowercased()
                }
            }
            .joined()
    }
}
