import GaniLib

class TransactionListScreen: GScreen {
    fileprivate let tableView = GTableView()
    fileprivate var transactions = [Transaction]()
    lazy fileprivate var refresher: GRefreshControl = {
        return GRefreshControl().onValueChanged {
            self.onRefresh()
        }
    }()
    
    open override func screenContent() -> UIView {
        return self.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.title("Transactions")
            .color(bg: .navbarBg, text: .navbarText)

        self
            .leftMenu(controller: MyMenuNavController())
            .paddings(t: 0, l: 0, b: 0, r: 0)
            .end()

        tableView
            .autoRowHeight(estimate: 300)
            .delegate(self)
            .source(self)
            .reload()
            .end()

        tableView.addSubview(refresher)
        
        onRefresh()
    }
    
    override func onRefresh() {
        self.transactions.removeAll()
        
        let params = [
            "apikey": "8XY5G7CC8CYMAJ267UBE58QNWDG1H49JHT",
            "module": "account",
            "action": "txlist",
            "address": "0xab86ca6c0e64092c4f444af47a2bebba67f6cd7b",
//            "startblock": "0",
//            "endblock": "99999999",
            "sort": "desc",
            "page": "1",
            "offset": "50"
        ]
        
        _ = Rest.get(url: "\(Build.instance.etherscanHost())/api", params: params).execute(indicator: refresher) { json in
            for transactionJson in json["result"].arrayValue {
                self.transactions.append(Transaction(json: transactionJson))
            }

            self.tableView.reloadData()
            return true
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
}
