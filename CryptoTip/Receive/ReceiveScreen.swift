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
        
        container.header.addView(addressPanel)
        container.content.addView(scrollPanel.paddings(t: 10, l: 10, b: 10, r: 10))
        
        if let address = addressPanel.address {
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
                .withView(qrView.source(image: QRCode(address)?.image)), top: 20)
        }
        else {
            scrollPanel.addView(
                GLabel()
                    .paddings(t: nil, l: 10, b: nil, r: 10)
                    .width(.matchParent)
                    .align(.center)
                    .text("Please set up your wallet from the Settings screen")
                , top: 40
            )
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.addressPanel.reload()
//
//        if let address = addressPanel.address {
//            _ = qrView.source(image: QRCode(address)?.image)
//        }
//    }
}
