import GaniLib
import EthereumKit

class EthNet {
    static let instance = RinkebyNet()
}

protocol EthNetConfig {
    var simpleName: String { get }
    var etherscanHost: String { get }
    var network: Network { get }
    var geth: Geth { get }
}

class RinkebyNet: EthNet {
    public var simpleName: String {
        get {
            return "rinkeby"
        }
    }
    
    var etherscanHost: String {
        get {
            return "https://rinkeby.etherscan.io"
        }
    }
    
    var network: Network {
        get {
            // TODO: This needs to be configurable
            return Network.private(chainID: 4, testUse: true)
        }
    }
    
    var geth: Geth {
        get {
            let configuration = Configuration(
                network: EthNet.instance.network,
                nodeEndpoint: "https://rinkeby.infura.io/z1sEfnzz0LLMsdYMX4PV",
                etherscanAPIKey: "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7",
                debugPrints: true
            )
            
            return Geth(configuration: configuration)
        }
    }
}
