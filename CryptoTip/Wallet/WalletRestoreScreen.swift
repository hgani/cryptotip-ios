import GaniLib
import KeychainSwift

class WalletRestoreScreen: GScreen {
    private let phraseField = GTextView().width(.matchParent).height(100).specs(.standard)
    
    private let passwordField = GTextField().width(.matchParent).specs(.standard).secure(true).placeholder("Password")
    private let confirmPasswordField = GTextField().width(.matchParent).specs(.standard).secure(true).placeholder("Confirm password")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Restore Wallet"
        nav
            .color(bg: .navbarBg, text: .navbarText)

        scrollPanel
            .paddings(t: 10, l: 20, b: 10, r: 20)
            .done()
        
        if Settings.instance.hasWallet() {
            scrollPanel.addView(GLabel()
                .specs(.p, .danger)
                .text("This will replace the current wallet. Make sure you've backed up the wallet before restoring another one."), top: 50)
        }
        
        scrollPanel.addView(GLabel().text("Enter your 24 backup phrases"), top: 20)
        scrollPanel.addView(phraseField, top: 5)
        
        scrollPanel.addView(GLabel().text("Enter password to protect the restored wallet"), top: 20)
        scrollPanel.addView(passwordField, top: 10)
        scrollPanel.addView(confirmPasswordField, top: 10)
        
        scrollPanel.addView(GAligner().width(.matchParent).withView(GButton()
            .specs(.primary)
            .title("Restore wallet")
            .onClick { _ in
                self.restoreWallet()
            }), top: 10
        )
    }
    
    private func restoreWallet() {
        let helper = WalletHelper(screen: self)

        guard let password = helper.validatePassword(field: passwordField, confirmField: confirmPasswordField) else {
            return
        }
        
        let mnemonic = phraseField.text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        if mnemonic.count > 0 {
            if let (publicKey, encryptedPrivateKey) = helper.createWallet(mnemonic: mnemonic, password: password) {
                KeychainSwift().set(encryptedPrivateKey, forKey: Keys.dbPrivateKey)
                DbJson.instance.set(Json(publicKey), forKey: Keys.dbPublicKey)
                
                self.indicator.show(success: "Done!")
                self.nav.pop().done()
            }
        }
    }
}
