import GaniLib
import KeychainSwift

class Settings {
    static let instance = Settings()
    let keychain = KeychainSwift()
    
    private var _fiatCurrency = DbJson.instance.object(forKey: Keys.dbFiatCurrency).string ?? "USD"
    var fiatCurrency: String {
        set {
            self._fiatCurrency = newValue
            DbJson.instance.set(Json(newValue), forKey: Keys.dbFiatCurrency)
        }
        get {
            return self._fiatCurrency
        }
    }
    
    // Public key may change when a new wallet is created
    var publicKey: String? {
        return DbJson.instance.object(forKey: Keys.dbPublicKey).string
    }
    
    func hasWallet() -> Bool {
        return keychain.getData(Keys.dbPrivateKey) != nil
    }
}
