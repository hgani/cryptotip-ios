import GaniLib
import KeychainSwift

class Settings {
    static let instance = Settings()
    let keychain = KeychainSwift()
    
    // Public key may change when a new wallet is created
    var publicKey: String? {
        return DbJson.instance.object(forKey: Keys.dbPublicKey).string
    }
    
    func hasWallet() -> Bool {
        return keychain.getData(Keys.dbPrivateKey) != nil
    }
}
