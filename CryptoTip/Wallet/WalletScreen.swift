import GaniLib
import CryptoSwift
import CryptoEthereumSwift
import EthereumKit
import RNCryptor
import KeychainSwift

class WalletScreen: GScreen {
//    let network: Network = Network.private(chainID: 4, testUse: true)
//    open private(set) lazy var geth: Geth! = {
//        let configuration = Configuration(
//            network: network,
//            nodeEndpoint: "https://rinkeby.infura.io/z1sEfnzz0LLMsdYMX4PV",
//            etherscanAPIKey: "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7",
//            debugPrints: true
//        )
//
//        let geth = Geth(configuration: configuration)
//            return geth
//    }()
    
    private let passwordField = GTextField().width(.matchParent).spec(.standard).secure(true).placeholder("Password")
    private let confirmPasswordField = GTextField().width(.matchParent).spec(.standard).secure(true).placeholder("Confirm password")
    private let phraseLabel = GLabel().spec(.p)
    private let confirmCreateButton = GButton().title("Confirm").spec(.standard).hidden(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wallet"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        scrollPanel
            .paddings(t: 10, l: 20, b: 10, r: 20)
            .done()
        
        scrollPanel.addView(passwordField, top: 50)
        scrollPanel.addView(confirmPasswordField, top: 10)
        
        scrollPanel.addView(GAligner().width(.matchParent).withView(GButton()
            .spec(.primary)
            .title("Create wallet")
            .onClick { _ in
                self.createMnemonic()
            }), top: 10
        )
        
        scrollPanel.addView(phraseLabel, top: 30)
        scrollPanel.addView(GAligner().width(.matchParent).withView(confirmCreateButton), top: 10)
    }
    
    func createMnemonic() {
        guard let password = passwordField.text, password.count >= 8 else {
            self.launch.alert("Specify a password (min 8 characters). This will be used to secure your private key.")
            return
        }
        
        guard password == confirmPasswordField.text else {
            self.launch.alert("Password confirmation does not match")
            return
        }
        
        let mnemonic = Mnemonic.create(strength: .hight, language: .english)
        phraseLabel.text(mnemonic.joined(separator: " ")).done()
        confirmCreateButton.hidden(false).onClick { _ in
            self.createWallet(mnemonic: mnemonic, password: password)
            self.indicator.show(success: "Done!")
            self.nav.pop().done()
            }.done()
    }
    
    func createWallet(mnemonic: [String], password: String) {
        // TODO: Handle errors
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: Settings.instance.network(), debugPrints: true)
        
        let data = wallet.dumpPrivateKey().data(using: .utf8)
        let encryptedPrivateKey = RNCryptor.encrypt(data: data!, withPassword: password)
        
        let keychain = KeychainSwift()
        keychain.set(encryptedPrivateKey, forKey: Keys.dbPrivateKey)
        
        DbJson.put(Keys.dbPublicKey, Json(wallet.generateAddress()))
    }
}
