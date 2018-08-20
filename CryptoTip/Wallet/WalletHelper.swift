import GaniLib
import CryptoSwift
import CryptoEthereumSwift
import EthereumKit
import RNCryptor

class WalletHelper {
    private let screen: GScreen
    
    init(screen: GScreen) {
        self.screen = screen
    }
    
    func validatePassword(field: GTextField, confirmField: GTextField) -> String? {
        guard let password = field.text, password.count >= 8 else {
            screen.launch.alert("Specify a password (min 8 characters). This will be used to secure your private key.")
            return nil
        }
        
        guard password == confirmField.text else {
            screen.launch.alert("Password confirmation does not match")
            return nil
        }
        
        return password
    }
    
    func createWallet(mnemonic: [String], password: String) -> (String, Data)? {
        do {
            let seed = try Mnemonic.createSeed(mnemonic: mnemonic)
            let wallet = try Wallet(seed: seed, network: EthNet.instance.network, debugPrints: true)
            
            let data = wallet.dumpPrivateKey().data(using: .utf8)
            let encryptedPrivateKey = RNCryptor.encrypt(data: data!, withPassword: password)
            let publicKey = wallet.generateAddress()
            return (publicKey, encryptedPrivateKey)
        }
        catch {
            screen.launch.alert("Failed creating wallet: \(error.localizedDescription)")
            return nil
        }
    }
}
