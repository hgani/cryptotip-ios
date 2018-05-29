import GaniLib
import Eureka

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
                    if let address = self.addressField.value {
                        DbJson.set(Keys.dbWalletAddress, Json(address))
                    }
                    self.nav.pop().refresh()
                }))
            .end()
        
        form += [section]
        
        section.append(addressField)
    }
}
