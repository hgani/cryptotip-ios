import GaniLib

class TransactionCell: GTableViewCustomCell {
    let txHash = GLabel().specs(.h1)
    let price = GLabel().specs(.p)
    
    required init(style: UITableViewCellStyle) {
        super.init(style: style)
        
        self
            .append(txHash)
            .append(price)
            .done()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
