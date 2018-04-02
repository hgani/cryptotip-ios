import GaniLib

class TransactionCell: GTableViewCustomCell {
    let txHash = GLabel().spec(.h1)
    let price = GLabel().spec(.p)
    
    required init(style: UITableViewCellStyle) {
        super.init(style: style)
        
        self
            .append(txHash)
            .append(price)
            .end()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
