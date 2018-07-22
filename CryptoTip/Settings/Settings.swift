import GaniLib
import KeychainSwift
import EthereumKit

class Settings {
    static let instance = Settings()
    let keychain = KeychainSwift()
    let publicKey = DbJson.get(Keys.dbPublicKey).stringValue
    
    func hasWallet() -> Bool {
        return keychain.getData(Keys.dbPrivateKey) != nil
    }
    
    func network() -> Network {
        // TODO: This needs to be configurable
        return Network.private(chainID: 4, testUse: true)
    }
    
    func geth() -> Geth {
        let configuration = Configuration(
            network: Settings.instance.network(),
            nodeEndpoint: "https://rinkeby.infura.io/z1sEfnzz0LLMsdYMX4PV",
            etherscanAPIKey: "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7",
            debugPrints: true
        )
        
        return Geth(configuration: configuration)
    }
}
