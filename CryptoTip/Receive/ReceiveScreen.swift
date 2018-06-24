import GaniLib
import QRCode
import web3swift

class ReceiveScreen: GScreen {
    private lazy var addressPanel = WalletAddressPanel(nav: nav)
    private let qrView = GImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receive"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .paddings(t: 10, l: 10, b: 10, r: 10)
            .done()
        
        container.addView(addressPanel)
        container.addView(GAligner()
            .width(.matchParent)
            .withView(qrView), top: 50)

//        let web3 = Web3.InfuraRinkebyWeb3()
//        let blockNumber = web3.eth.getBlockNumber()
//        GLog.t("Number = \(blockNumber)")
        
        onRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addressPanel.reload()
        _ = qrView.source(image: QRCode(addressPanel.address)?.image)
    }
}
