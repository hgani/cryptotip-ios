import GaniLib
import Eureka
import web3swift

class SettingsScreen: GFormScreen {
    private var section = Section()
    private let addressField = TextRow("to") { row in
        row.title = "Wallet address"
        row.placeholder = "Enter to view transaction history"
        row.value = DbJson.get(Keys.dbWalletAddress).string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)
        
        self
            .rightBarButton(item: GBarButtonItem()
                .icon(from: .FontAwesome, code: "save")
                .onClick({
                    if let value = self.addressField.value, let address = EthereumAddress(value), address.isValid {
                        DbJson.set(Keys.dbWalletAddress, Json(value))
                        self.nav.pop().refresh()
                    }
                    else {
                        self.launch.alert("Invalid ETH address")
                    }
                }))
            .end()
        
        form += [section]
        
        section.append(addressField)
    }
}
