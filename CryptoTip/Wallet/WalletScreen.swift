import GaniLib
import CryptoSwift
import CryptoEthereumSwift
import EthereumKit
import RNCryptor

class WalletScreen: GScreen {
    let network: Network = Network.private(chainID: 4, testUse: true)
    open private(set) lazy var geth: Geth! = {
        let configuration = Configuration(
            network: network,
            nodeEndpoint: "https://rinkeby.infura.io/z1sEfnzz0LLMsdYMX4PV",
            etherscanAPIKey: "XE7QVJNVMKJT75ATEPY1HPWTPYCVCKMMJ7",
            debugPrints: true
        )
    
        let geth = Geth(configuration: configuration)
            return geth
    }()
    
    private let phraseLabel = GLabel().spec(.p)
    private let confirmButton = GButton().title("Confirm").spec(.standard).hidden(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wallet"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .paddings(t: 10, l: 20, b: 10, r: 20)
            .done()

        container.addView(GAligner().width(.matchParent).withView(GButton()
            .spec(.primary)
            .title("Create wallet")
            .onClick { _ in
                self.createMnemonic()
            }), top: 50
        )
        
        container.addView(phraseLabel, top: 30)
        container.addView(GAligner().width(.matchParent).withView(confirmButton), top: 10)
    }
    
    func createMnemonic() {
        let mnemonic = Mnemonic.create(strength: .hight, language: .english)
        
        phraseLabel.text(mnemonic.joined(separator: " ")).done()
        confirmButton.hidden(false).onClick { _ in
            self.createWallet(mnemonic: mnemonic)
            self.indicator.show(success: "Done!")
            self.nav.pop().done()
        }.done()
    }
    
    func createWallet(mnemonic: [String]) {
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        let wallet = try! Wallet(seed: seed, network: network, debugPrints: true)
        
        let data = wallet.dumpPrivateKey().data(using: .utf8)
        let encryptedPrivateKey = RNCryptor.encrypt(data: data!, withPassword: "TODO")
        DbJson.put(Keys.dbPrivateKey, Json(encryptedPrivateKey))
        
//        DbJson.put(Keys.dbPrivateKey, Json(wallet.dumpPrivateKey()))
        DbJson.put(Keys.dbPublicKey, Json(wallet.generateAddress()))
    }
}
