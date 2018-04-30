import GaniLib
import QRCode
import web3swift

class ReceiveScreen: GScreen {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Receive"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .paddings(t: 20, l: 20, b: 20, r: 20)
            .end()
        
        let qrCode = QRCode("TEST")
        container.addView(GAligner()
            .width(.matchParent)
            .withView(GImageView().source(image: qrCode?.image)), top: 50)

//        let web3 = Web3.InfuraRinkebyWeb3()
//        let blockNumber = web3.eth.getBlockNumber()
//        GLog.t("Number = \(blockNumber)")
    }
}
