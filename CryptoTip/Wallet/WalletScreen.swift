import GaniLib
import CryptoSwift
import CryptoEthereumSwift
import EthereumKit

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
    
    var wallet: Wallet! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wallet"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .paddings(t: 10, l: 10, b: 10, r: 10)
            .done()

        container.addView(GAligner().width(.matchParent).withView(GButton()
            .spec(.primary)
            .title("Create wallet")
            .onClick { _ in
                self.createWallet()
            }), top: 50
        )
    }
    
    func createWallet() {
        let mnemonic = Mnemonic.create(strength: .hight, language: .english)
        let seed = try! Mnemonic.createSeed(mnemonic: mnemonic)
        wallet = try! Wallet(seed: seed, network: network, debugPrints: true)

        DbJson.put(Keys.dbPrivateKey, Json(wallet.dumpPrivateKey()))
        DbJson.put(Keys.dbPublicKey, Json(wallet.generateAddress()))
        
        container.addView(GLabel()
            .text(mnemonic.joined(separator: " "))
        )
    }
}
