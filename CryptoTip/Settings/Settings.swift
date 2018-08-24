import GaniLib
import KeychainSwift

class Settings {
    static let instance = Settings()
    let keychain = KeychainSwift()
    
    private var _fiatCurrency = DbJson.instance.object(forKey: Keys.Db.fiatCurrency).string ?? "USD"
    var fiatCurrency: String {
        set {
            self._fiatCurrency = newValue
            DbJson.instance.set(Json(newValue), forKey: Keys.Db.fiatCurrency)
        }
        get {
            return self._fiatCurrency
        }
    }
    
    // Public key may change when a new wallet is created
    var publicKey: String? {
        return DbJson.instance.object(forKey: Keys.Db.publicKey).string
    }
    
    func hasWallet() -> Bool {
        return keychain.getData(Keys.Db.privateKey) != nil
    }
}
