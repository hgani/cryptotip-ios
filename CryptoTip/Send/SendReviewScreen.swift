import GaniLib
import Eureka
//import web3swift
import KeychainSwift
import RNCryptor
import EthereumKit

class SendReviewScreen: GScreen {
    private let passwordField = GTextField().width(.matchParent).specs(.standard).secure(true).placeholder("Password")
    
    private let payload: TxPayload
    
    init(payload: TxPayload) {
        self.payload = payload
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Review"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)
        
        container.content.addView(
            scrollPanel.paddings(t: 20, l: 20, b: 20, r: 20)
        )
        
        scrollPanel.paddings(t: 40, l: 20, b: 10, r: 20).done()
        
        scrollPanel.addView(GLabel().text("To: \(payload.recipient)"))
        scrollPanel.addView(GLabel().text("Amount: \(payload.amount) ETH"), top: 10)
        
        scrollPanel.addView(passwordField, top: 30)
        scrollPanel.addView(GButton().specs(.standard).title("Send").onClick { _ in
            self.executeTransaction()
        }, top: 10)

        onRefresh()
    }
    
    private func executeTransaction() {
        self.indicator.show()
        
        let encData = KeychainSwift().getData(Keys.Db.privateKey) ?? Data()
        guard let decData = try? RNCryptor.decrypt(data: encData, withPassword: self.passwordField.text ?? ""), let key = String(data: decData, encoding: .utf8) else {
            self.alert("Wrong password")
            return
        }
        
        let wallet = Wallet(network: EthNet.instance.network, privateKey: key, debugPrints: true)
        let address = wallet.generateAddress()
        
        EthNet.instance.geth.getTransactionCount(of: address) { (result) in
            switch result {
            case .success(let nonce):
                self.submitTransaction(wallet: wallet, nonce: nonce)
                break
            case .failure(let error):
                self.alert("Failed initiating transaction: \(error.localizedDescription)")
            }
        }
    }
    
    private func alert(_ message: String) {
        self.indicator.hide()
        self.launch.alert(message)
    }
    
    private func submitTransaction(wallet: Wallet, nonce: Int) {
        guard let wei = try? Converter.toWei(ether: Ether(payload.amount)) else {
            self.alert("Invalid amount")
            return
        }
        
        let rawTx = RawTransaction(value: wei, to: self.payload.recipient, gasPrice: Converter.toWei(GWei: 10), gasLimit: 21000, nonce: nonce)
        guard let tx = try? wallet.sign(rawTransaction: rawTx) else {
            self.alert("Failed signing transaction")
            return
        }
        
        EthNet.instance.geth.sendRawTransaction(rawTransaction: tx) { transaction in
            switch transaction {
            case .success(let tx):
                self.alert("Done. Transaction ID: \(tx.id)")
                break
            case .failure(let error):
                self.alert("Failed submitting transaction: \(error.localizedDescription)")
            }
        }
    }
}

struct TxPayload {
    let recipient: String
    let amount: Double
}
