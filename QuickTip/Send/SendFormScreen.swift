import GaniLib
import Eureka

class SendFormScreen: GFormScreen {
    private var conversionRate: Float = 0.0
    private let to: String
    private var section = Section()
    
    private var destinationField = TextRow("to") { row in
        row.title = "Send to"
    }
    
    private var conversionField = DataListRow(nil) { row in
        row.title = "AUD Amount"
        row.options = ["5", "10", "20"]
//        row.cellStyle = .subtitle
    }
    
    private var amountField = TextRow("amount") { row in
        row.title = "ETH to be sent"
    }
    
    init(to: String) {
        self.to = to
        destinationField.value = to
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
//                .append(GLabel().text("To: \(self.to)"))
                .end()
        }
        
        section.append(destinationField)
        section.append(conversionField)
        
//            .intro("The amount of ETH to be sent will be calculated based on Specify amount in AUD\n\n1 ETH = AUD")

        section.append(amountField)
        
        section.append(ButtonRow() { row in
            row.title = "Review"
            }.onCellSelection { (cell, row) in
                let values = self.values()
                if let amount = Float(values["amount"] as! String) {
                    let url = "ethereum:\(self.to)?amount=\(amount)"
                    GLog.i("URL: \(url)")
                    self.launch.url(url)
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
        _ = Rest.get(url: "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=AUD").execute(indicator: .null) { result in
            if let rate = result["AUD"].float {
                self.conversionRate = 1 / rate
//                self.conversionField.cellUpdate { cell, _ in
//                    cell.detailTextLabel?.text = "1 AUD = \(self.conversionRate) ETH"
//                }
                
                self.conversionField
                    .intro("Specify the amount you want to send in AUD\n1 AUD = \(self.conversionRate) ETH")
                self.tableView.reloadData()
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
            populate(view.clear())
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
