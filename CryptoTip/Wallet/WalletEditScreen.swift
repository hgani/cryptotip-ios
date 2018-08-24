import GaniLib
import Eureka
import web3swift

class WalletEditScreen: GFormScreen {
    private var section = Section()
    private let addressField = TextRow("to") { row in
        row.title = "Wallet address"
        row.placeholder = "Enter to view transaction history"
        row.value = DbJson.instance.object(forKey: Keys.Db.publicKey).string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)
        
        self
            .rightBarButton(item: GBarButtonItem()
                .icon(from: .fontAwesome, code: "save")
                .onClick({
                    if let value = self.addressField.value, let address = EthereumAddress(value), address.isValid {
                        DbJson.instance.set(Json(value), forKey: Keys.Db.publicKey)
                        self.nav.pop().done()
                    }
                    else {
                        self.launch.alert("Invalid ETH address")
                    }
                }))
            .done()
        
        form += [section]
        
        section.append(addressField)
    }
}
