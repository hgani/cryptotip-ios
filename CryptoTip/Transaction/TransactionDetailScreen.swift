import GaniLib

class TransactionDetailScreen: GScreen {
    private let transaction: Transaction
    
    init(transaction: Transaction) {
        self.transaction = transaction
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = transaction.hash
        nav
            .color(bg: .navbarBg, text: .navbarText)
        
        container.addView(
            GVerticalPanel().paddings(t: 10, l: 10, b: 40, r: 10)
                .append(GLabel().spec(.h1).text(transaction.hash), top: 20)
                .append(GLabel().spec(.p).text("\(transaction.valueInEth) ETH"), top: 10)
        )
    }
}


