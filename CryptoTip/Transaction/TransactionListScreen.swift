import GaniLib

class TransactionListScreen: GScreen {
    fileprivate let tableView = GTableView().width(.matchParent).height(.matchParent)
    fileprivate var transactions = [Transaction]()
    fileprivate lazy var addressPanel = WalletAddressPanel(nav: nav)
    
    private let tableHeader = GHeaderFooterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Transactions"
        
        nav
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .done()

        container.content.addView(
            tableView
                .autoRowHeight(estimate: 300)
                .delegate(self)
                .source(self)
                .reload()
        )

        tableView.addSubview(refresher)
        
//        DbJson.set(Keys.dbTxListAddress, "")
        
        onRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Settings.instance.publicKey != addressPanel.address {
            onRefresh()
        }
    }
    
    override func onRefresh() {
        self.addressPanel.reload()
        self.transactions.removeAll()
        self.tableView.reloadData()
        
        if let address = Settings.instance.publicKey {
            let params = [
                "apikey": "8XY5G7CC8CYMAJ267UBE58QNWDG1H49JHT",
                "module": "account",
                "action": "txlist",
                "address": address,
                //            "startblock": "0",
                //            "endblock": "99999999",
                "sort": "desc",
                "page": "1",
                "offset": "50"
            ]
            
            _ = Rest.get(url: "\(Build.instance.etherscanHost())/api", params: params).execute(indicator: refresher) { json in
                let items = json["result"].arrayValue
                if items.count > 0 {
                    for transactionJson in items {
                        self.transactions.append(Transaction(json: transactionJson))
                    }
                }
                else {
                    self.tableHeader
                        .clear()
                        .append(self.addressPanel)
                        .append(GLabel()
                            .paddings(t: 30, l: 20, b: 10, r: 20)
                            .specs(.p)
                            .align(.center)
                            .text("You haven't made a transaction. Please send coins from the Send screen."))
                        .done()
                }
                self.tableView.reloadData()
                return true
            }
        }
    }
}

extension TransactionListScreen: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    private func transaction(at indexPath: IndexPath) -> Transaction {
        return transactions[indexPath.row]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.cellInstance(of: TransactionCell.self, style: .default)
        
        let transaction = self.transaction(at: indexPath)
        cell.txHash.text = transaction.hash
        cell.price.text = "\(transaction.valueInEth) ETH"
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nav.push(TransactionDetailScreen(transaction: transaction(at: indexPath)))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeader
    }
}
