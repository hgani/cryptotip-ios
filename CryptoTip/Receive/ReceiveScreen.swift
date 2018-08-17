import GaniLib
import QRCode
import web3swift

class ReceiveScreen: GScreen {
    private lazy var addressPanel = WalletAddressPanel(nav: nav)
    private let qrView = GImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receive a tip"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .done()
        
        container.content.addView(
            scrollPanel.paddings(t: 10, l: 10, b: 10, r: 10)
        )

        scrollPanel.addView(addressPanel)
        scrollPanel.addView(
            GLabel()
                .paddings(t: nil, l: 10, b: nil, r: 10)
                .width(.matchParent)
                .align(.center)
                .text("Present this QR code to the tipper to receive coins")
            , top: 50
        )
        scrollPanel.addView(GAligner()
            .width(.matchParent)
            .withView(qrView), top: 20)

//        let web3 = Web3.InfuraRinkebyWeb3()
//        let blockNumber = web3.eth.getBlockNumber()
//        GLog.t("Number = \(blockNumber)")
        
        onRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addressPanel.reload()
        
        if let address = addressPanel.address {
            _ = qrView.source(image: QRCode(address)?.image)
        }
    }
}
