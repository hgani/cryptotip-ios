import GaniLib
import Eureka

class SendFormScreen: GFormScreen {
    private var conversionRate: Float = 0.0
    private var section1 = Section()
    private var section2 = Section()
    
    private let fiatToEthLabel = GLabel().font(nil, size: 14)
    private let ethToFiatLabel = GLabel().font(nil, size: 14)
    
    private let fiatCurrency = "AUD"
    
    private let conversionField = DataListRow(nil) { row in
        row.options = ["5", "10", "20"]
    }
    
    private let amountField = TextRow("amount") { row in
        row.title = "ETH to be sent"
    }
    
    private let destinationField = TextRow("to") { row in
        row.title = "Send to"
    }
    
    init(to: String) {
        destinationField.value = to
        conversionField.title = "\(fiatCurrency) Amount"
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
        
        form += [section1, section2]
        
        section1.append(destinationField)
        
        section2.header = setupHeaderFooter() { view in
            view
                .paddings(t: 10, l: 20, b: 10, r: 20)
                .append(GSplitPanel().width(.matchParent).withViews(self.fiatToEthLabel, self.ethToFiatLabel))
                .end()
        }
        
        section2.append(conversionField)
        section2.append(amountField)
        
        section2.append(ButtonRow() { row in
            row.title = "Review and Send"
            }.onCellSelection { (cell, row) in
                let values = self.values()
                if let amountText = values["amount"] as? String, let amount = Float(amountText), let recipient = self.destinationField.value {
                    let url = "ethereum:\(recipient)?amount=\(amount)"
                    GLog.i("URL: \(url)")
                    self.launch.url(url)
                }
                else {
                    self.launch.alert("Please enter amount and recipient")
                }
        })
        
        conversionField.onChange { row in
            if let dollarAmount = Float(row.value ?? "") {
                self.amountField.value = String(dollarAmount * self.conversionRate)
                self.tableView.reloadData()
            }
        }

//        self
//            .leftMenu(controller: MyMenuNavController())
//            .paddings(t: 20, l: 20, b: 20, r: 20)
//            .end()
        
        onRefresh()
    }
    
    override func onRefresh() {
        _ = self.fiatToEthLabel.text("Retrieving ETH price ...")

        _ = Rest.get(url: "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=\(fiatCurrency)").execute(indicator: .null) { result in
            if let rate = result[self.fiatCurrency].float {
                self.conversionRate = 1 / rate
                _ = self.fiatToEthLabel.text("1 \(self.fiatCurrency) = \(self.conversionRate) ETH")
                _ = self.ethToFiatLabel.text("1 ETH = \(rate) \(self.fiatCurrency)")
                
                _ = self.conversionField.intro("Specify the amount to send in \(self.fiatCurrency)\n1 \(self.fiatCurrency) = \(self.conversionRate) ETH")
                self.tableView.reloadData()
                return true
            }
            else {
                _ = self.fiatToEthLabel.text("Failed!")
            }
            return false
        }
    }
    
//    private func setupHeaderFooter(height: Int? = nil, populate: @escaping (GHeaderFooterView) -> Void) -> HeaderFooterView<GHeaderFooterView> {
//        var headerFooter = HeaderFooterView<GHeaderFooterView>(.class)
//        headerFooter.height = {
//            if let h = height {
//                return CGFloat(h)
//            }
//            return UITableViewAutomaticDimension
//        }
//        headerFooter.onSetupView = { view, section in
//            populate(view.clear())
//        }
//        return headerFooter
//    }
}
