import GaniLib

class WalletAddressPanel: GVerticalPanel {
    public private(set) var address = ""
    private let nav: NavHelper
    private let addressLabel = GLabel().specs(.small)
    
    init(nav: NavHelper) {
        self.nav = nav
        super.init()
        
        let addressView = GVerticalPanel()
            .append(GLabel().text("Your wallet address:"))
            .append(addressLabel)
        let content = GSplitPanel()
            .paddings(t: 10, l: 10, b: 10, r: 10)
            .width(.matchParent)
            .withViews(
                addressView,
                //                GLabel().text("Wallet address: \(address.isEmpty ? "[unspecified]" : address)"),
                GLabel().specs(.a).text("settings").onClick { _ in
                    nav.push(SettingsScreen())
            })
        width(.matchParent).addView(content)
        
        reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload() {
//        self.address = DbJson.get(Keys.dbPublicKey).stringValue
        self.address = Settings.instance.publicKey
        _ = self.addressLabel.text("\(address.isEmpty ? "[unspecified]" : address)")
    }
}
