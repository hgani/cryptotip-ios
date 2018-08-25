import GaniLib
import EthereumKit
import KeychainSwift

class WalletCreateScreen: GScreen {
    private let passwordField = GTextField().width(.matchParent).specs(.standard).secure(true).placeholder("Password")
    private let confirmPasswordField = GTextField().width(.matchParent).specs(.standard).secure(true).placeholder("Confirm password")
    
    private let walletPanel = GVerticalPanel().hidden(true)
    private let addressLabel = GLabel().width(.matchParent).paddings(t: 5, l: 10, b: 5, r: 10).color(bg: .lightShade).specs(.small).copyable()
    private let phraseLabel = GLabel().width(.matchParent).paddings(t: 5, l: 10, b: 5, r: 10).color(bg: .lightShade).specs(.p).copyable()
    private let confirmCreateButton = GButton().title("Confirm").specs(.standard)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Generate Wallet"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        container.content.addView(
            scrollPanel
                .paddings(t: 10, l: 20, b: 10, r: 20)
        )
        
        if Settings.instance.hasWallet() {
            scrollPanel.addView(GLabel()
                .specs(.p, .danger)
                .text("This will replace the current wallet. Make sure you've backed up the wallet before creating a new one."), top: 50)
        }
        
        scrollPanel.addView(GLabel().text("Enter password to protect your new wallet"), top: 20)
        scrollPanel.addView(passwordField, top: 10)
        scrollPanel.addView(confirmPasswordField, top: 10)
        
        scrollPanel.addView(GAligner().width(.matchParent).withView(GButton()
            .specs(.primary)
            .title("Generate wallet...")
            .onClick { _ in
                self.generateMnemonic()
            }), top: 10
        )
        
        scrollPanel.addView(
            walletPanel
                .append(GLabel().text("Address"), top: 10)
                .append(addressLabel, top: 2)
                .append(GLabel().text("Backup phrases (write this down, don't lose it)"), top: 20)
                .append(phraseLabel, top: 2)
                .append(GAligner().width(.matchParent).withView(confirmCreateButton), top: 10)
            , top: 20
        )
    }
    
    func generateMnemonic() {
        let helper = WalletHelper(screen: self)
        
        guard let password = helper.validatePassword(field: passwordField, confirmField: confirmPasswordField) else {
            return
        }
        
        let mnemonic = Mnemonic.create(strength: .hight, language: .english)
        if let (publicKey, encryptedPrivateKey) = helper.createWallet(mnemonic: mnemonic, password: password) {
            addressLabel.text(publicKey).done()
            phraseLabel.text(mnemonic.joined(separator: " ")).done()
            
            confirmCreateButton.onClick { _ in
                KeychainSwift().set(encryptedPrivateKey, forKey: Keys.Db.privateKey)
                DbJson.instance.set(Json(publicKey), forKey: Keys.Db.publicKey)
                
                self.indicator.show(success: "Done!")
                self.nav.pop().done()
                }.done()
            
            walletPanel.hidden(false).done()
        }
    }
}
