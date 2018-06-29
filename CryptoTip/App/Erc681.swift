import GaniLib

class Erc681 {
    private let schema = "ethereum"
    private let recipient: String
    private let chainId: Int
    private let value: String
    private let gasLimit: String
    private let gasPrice: String
    private let gas: String
    
    init?(url: URL) {
        let urlString = url.absoluteString
        guard urlString.starts(with: "\(schema):") else {
            return nil
        }
        
        var newUrl = url
        if !urlString.starts(with: "\(schema)://") {
            let regex = try? NSRegularExpression(pattern: "^\(schema):", options: [])
            let newString = regex!.stringByReplacingMatches(in: urlString, options: [], range: NSMakeRange(0, urlString.count), withTemplate: "$1//")
            newUrl = URL(string: newString)!
        }
        
        guard let host = newUrl.host else {
            return nil
        }
        
        let recipient: String
        if let chainId = Int(host) {
            if let user = newUrl.user {
                self.chainId = chainId
                recipient = user
            }
            else {
                return nil
            }
        }
        else {
            self.chainId = 1
            recipient = host
        }
        
        self.recipient = recipient.starts(with: "pay-") ? String(recipient.split(separator: "-")[1]) : recipient
        
        guard let value = newUrl.param(name: "value"),
            let gasLimit = newUrl.param(name: "gasLimit"),
            let gasPrice = newUrl.param(name: "gasPrice"),
            let gas = newUrl.param(name: "gas") else {
            return nil
        }
        self.value = value
        self.gasLimit = gasLimit
        self.gasPrice = gasPrice
        self.gas = gas
    }
    
//    static func parse(url: URL) {
//        var newURL = url
//        if newURL.absoluteString.range(of: "://") == nil {
//            let urlString = newURL.absoluteString.replacingOccurrences(of: ":", with: "://")
//            newURL = URL(string: urlString)!
//        }
//
//        var recipientAddress: String
//        var chainId: Int = 1
//
//        if Int(newURL.host!) == nil {
//            recipientAddress = newURL.host!
//        }
//        else {
//            chainId = Int(newURL.host!)!
//            recipientAddress = newURL.user!
//        }
//
//        if recipientAddress.range(of: "pay-") != nil {
//            recipientAddress = String((recipientAddress.split(separator: "-")[1]))
//        }
//
//        let value = newURL.param(name: "value")
//        let gasLimit = newURL.param(name: "gasLimit")
//        let gasPrice = newURL.param(name: "gasPrice")
//        let gas = newURL.param(name: "gas")
//
//        print(newURL.path)
//        print(recipientAddress)
//        print(chainId)
//        print(value)
//        print(gasLimit)
//        print(gasPrice)
//        print(gas)
//
//    }
}

private extension URL {
    func param(name: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == name })?.value
    }
}
