import GaniLib

class WalletAddressPanel: GVerticalPanel {
    public private(set) var address: String?
    private let nav: NavHelper
    private let addressLabel = GLabel().specs(.small).copyable()
    
    init(nav: NavHelper) {
        self.nav = nav
        super.init()
                
        let addressView = GVerticalPanel()
            .append(GLabel().text("Your wallet address:"))
            .append(addressLabel)
        let content = GSplitPanel()
            .width(.matchParent)
            .withViews(
                addressView,
                GLabel().specs(.a).text("settings").onClick { _ in
                    nav.push(SettingsScreen())
            })
        
        self.width(.matchParent)
            .paddings(t: 10, l: 10, b: 10, r: 10)
            .append(content)
            .append(GLabel().specs(.small).text("Network: \(EthNet.instance.simpleName)"), top: 10)
            .done()
        
        reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload() {
        self.address = Settings.instance.publicKey
        _ = self.addressLabel.text(address ?? "[not set-up]")
    }
}
