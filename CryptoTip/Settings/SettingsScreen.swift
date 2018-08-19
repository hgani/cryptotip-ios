import GaniLib
import Eureka
import web3swift

class SettingsScreen: GFormScreen {
    private var section = Section()
    private let addressLabel = GLabel().specs(.small).copyable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)
        
        form += [section]
        
        // TODO: Display balance
        section.header = setupHeaderFooter() { view in
            view
                .paddings(t: 10, l: 20, b: 10, r: 20)
                .append(GLabel().text("Wallet address:"))
                .append(self.addressLabel)
                .done()
        }
        
        // Hide this to simplify usage
//        section.append(LabelRow() { row in
//            row.title = "Enter existing wallet address"
//            row.cellStyle = .value1
//            }.cellUpdate { (cell, row) in
//                cell.accessoryType = .disclosureIndicator
//            }.onCellSelection { (cell, row) in
//                self.nav.push(WalletEditScreen())
//        })
        
        section.append(LabelRow() { row in
            row.title = "Create new wallet"
            row.cellStyle = .value1
        }.cellUpdate { (cell, row) in
            cell.accessoryType = .disclosureIndicator
        }.onCellSelection { (cell, row) in
            self.nav.push(WalletCreateScreen())
        })
        
        section.append(LabelRow() { row in
            row.title = "Restore wallet"
            row.cellStyle = .value1
            }.cellUpdate { (cell, row) in
                cell.accessoryType = .disclosureIndicator
            }.onCellSelection { (cell, row) in
                self.nav.push(WalletRestoreScreen())
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let address = Settings.instance.publicKey
        _ = addressLabel.text(address ?? "[not set-up]")
    }
}
