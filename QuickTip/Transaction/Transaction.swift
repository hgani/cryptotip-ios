import GaniLib

class Transaction {
    let hash: String
    let from: String
    let to: String
    let valueInWei: Double
    let valueInEth: Double
    let timeStamp: UInt64
    
    init(json: Json) {
        self.hash = json["hash"].stringValue
        self.from = json["from"].stringValue
        self.to = json["to"].stringValue
        self.valueInWei = json["value"].doubleValue
        self.valueInEth = valueInWei / pow(10, 18)
        self.timeStamp = json["timeStamp"].uInt64Value
    }
}
