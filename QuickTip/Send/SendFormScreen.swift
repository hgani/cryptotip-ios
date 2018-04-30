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
        
        section.header = setupHeaderFooter() { view in
            view
                .paddings(t: 10, l: 15, b: 10, r: 15)
                .append(GLabel().text("To: \(self.to)"))
                .end()
        }
        
        section.append(TextRow(nil) { row in
            row.title = "Amount in AUD"
        }.onChange { row in
            if let dollarAmount = Float(row.value ?? "") {
                self.amountField.value = String(dollarAmount / self.conversionRate)
            }
        })
        
        section.append(amountField)
        
        section.append(ButtonRow() { row in
            row.title = "Submit"
            }.onCellSelection { (cell, row) in
                let values = self.values()
                if let amount = Float(values["amount"] as! String) {
                    let url = "ethereum:\(self.to)?amount=\(amount)"
                    GLog.i("URL: \(url)")
                    self.launch.url(url)
                }
        })

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
