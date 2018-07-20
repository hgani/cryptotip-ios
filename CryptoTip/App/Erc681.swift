import GaniLib

class Erc681 {
    private let schema = "ethereum"
    let url: URL
    let recipient: String
    let chainId: Int
    let value: String?
    let gasLimit: String?
    let gasPrice: String?
    let gas: String?
    
    init?(url inUrl: URL?) {
        guard let origUrl = inUrl else {
            return nil
        }
        
        let urlString = origUrl.absoluteString
        guard urlString.starts(with: "\(schema):") else {
            return nil
        }
        
        if urlString.starts(with: "\(schema)://") {
            self.url = origUrl
        }
        else {
            let regex = try? NSRegularExpression(pattern: "^\(schema):", options: [])
            let newString = regex!.stringByReplacingMatches(in: urlString, options: [], range: NSMakeRange(0, urlString.count), withTemplate: "$1//")
            self.url = URL(string: newString)!
        }

        guard let host = url.host else {
            return nil
        }

        let recipient: String
        if let chainId = Int(host) {
            if let user = url.user {
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

        self.value = url.param(name: "value")
        self.gasLimit = url.param(name: "gasLimit")
        self.gasPrice = url.param(name: "gasPrice")
        self.gas = url.param(name: "gas")
    }
}

private extension URL {
    func param(name: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == name })?.value
    }
}
