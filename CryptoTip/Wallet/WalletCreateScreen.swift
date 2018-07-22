import GaniLib
import CryptoSwift
import CryptoEthereumSwift
import EthereumKit
import RNCryptor
import KeychainSwift

class WalletCreateScreen: GScreen {
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
    
    private let walletPanel = GVerticalPanel().hidden(true)
    private let addressLabel = GLabel().width(.matchParent).paddings(t: 5, l: 10, b: 5, r: 10).color(bg: .lightShade).specs(.small).copyable()
    private let phraseLabel = GLabel().width(.matchParent).paddings(t: 5, l: 10, b: 5, r: 10).color(bg: .lightShade).specs(.p).copyable()
    private let confirmCreateButton = GButton().title("Confirm").specs(.standard).hidden(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wallet"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        scrollPanel
            .paddings(t: 10, l: 20, b: 10, r: 20)
            .done()
        
        if Settings.instance.hasWallet() {
            scrollPanel.addView(GLabel()
                .specs(.p, .danger)
                .text("This will replace the current wallet. Make sure you've backed up the wallet before creating a new one."), top: 50)
        }
        
        scrollPanel.addView(passwordField, top: 20)
        scrollPanel.addView(confirmPasswordField, top: 10)
        
        scrollPanel.addView(GAligner().width(.matchParent).withView(GButton()
            .specs(.primary)
            .title("Generate wallet...")
            .onClick { _ in
                self.createMnemonic()
            }), top: 10
        )
        
        scrollPanel.addView(
            walletPanel
                .append(GLabel().text("Address"), top: 10)
                .append(addressLabel, top: 2)
                .append(GLabel().text("Backup phrases (write this down, don't lose it)"), top: 20)
                .append(phraseLabel, top: 2)
                .append(GAligner().width(.matchParent).withView(confirmCreateButton), top: 10)
            , top: 20
        )
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
        let (publicKey, encryptedPrivateKey) = createWallet(mnemonic: mnemonic, password: password)
        
        addressLabel.text(publicKey).done()
        phraseLabel.text(mnemonic.joined(separator: " ")).done()
        walletPanel.hidden(false).done()
        
        confirmCreateButton.hidden(false).onClick { _ in
            KeychainSwift().set(encryptedPrivateKey, forKey: Keys.dbPrivateKey)
            DbJson.instance.set(Json(publicKey), forKey: Keys.dbPublicKey)
            
            self.indicator.show(success: "Done!")
            self.nav.pop().done()
        }.done()
    }
    
    func createWallet(mnemonic: [String], password: String) -> (String, Data) {
        // TODO: Handle errors
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: Settings.instance.network(), debugPrints: true)
        
        let data = wallet.dumpPrivateKey().data(using: .utf8)
        let encryptedPrivateKey = RNCryptor.encrypt(data: data!, withPassword: password)
        let publicKey = wallet.generateAddress()
        return (publicKey, encryptedPrivateKey)
    }
}
