import GaniLib
import Eureka

class SendFormScreen: GFormScreen {
    private var conversionRate: Float = 0.0
    private let to: String
    private var section = Section()
    
    private var amountField = TextRow("amount") { row in
        row.title = "Amount in ETH"
    }
    
    init(to: String) {
        self.to = to
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Send"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)
        
        form += [section]
        
        section.append(TextRow(nil) { row in
            row.title = "Amount in AUD"
        }.onChange { row in
            if let dollarAmount = Float(row.value ?? "") {
                self.amountField.value = String(dollarAmount / self.conversionRate)
            }
        })
        
        section.append(amountField)
        
        let submitRow = ButtonRow() { row in
            row.title = "Submit"
        }.onCellSelection { (cell, row) in
            let values = self.values()
            GLog.t("VALUES: \(values)")
        }
        
        section.header = setupHeaderFooter() { view in
            view
                .paddings(t: 10, l: 20, b: 10, r: 20)
                .append(GLabel().text("To: \(self.to)"))
                .end()
        }
        
        section.append(submitRow)

//        self
//            .leftMenu(controller: MyMenuNavController())
//            .paddings(t: 20, l: 20, b: 20, r: 20)
//            .end()
        
        onRefresh()
    }
    
    override func onRefresh() {
        _ = Rest.get(url: "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=AUD").execute(indicator: refresher) { result in
            if let rate = result["AUD"].float {
                self.conversionRate = rate
                return true
            }
            return false
        }
    }
    
    private func setupHeaderFooter(height: Int? = nil, populate: @escaping (GHeaderFooterView) -> Void) -> HeaderFooterView<GHeaderFooterView> {
        var headerFooter = HeaderFooterView<GHeaderFooterView>(.class)
        headerFooter.height = {
            if let h = height {
                return CGFloat(h)
            }
            return UITableViewAutomaticDimension
        }
        headerFooter.onSetupView = { view, section in
            populate(view)
        }
        return headerFooter
    }
    
    func submit(code: String) {
//        _ = Rest.post(path: "/", params: params).execute { result in
//            if result["success"].boolValue {
//                self.dismiss(animated: true, completion: nil)
//                self.indicator.show(success: result["message"].stringValue)
//                return true
//            }
//            return false
//        }
    }
}
