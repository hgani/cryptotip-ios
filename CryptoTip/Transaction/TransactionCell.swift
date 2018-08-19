import GaniLib

class TransactionCell: GTableViewCustomCell {
//    let txHash = GLabel().specs(.small)
    
    let directionPanel = GVerticalPanel()
    let from = GLabel().specs(.small)
    let to = GLabel().specs(.small)
    let time = GLabel().specs(.small).color(.darkGray)
    
    let direct = GLabel().specs(.small).color(.darkGray)
    let price = GLabel().specs(.p)
    
    required init(style: UITableViewCellStyle) {
        super.init(style: style)
        
        self
            .selectionStyle(.none)
            .paddings(t: 8, l: 14, b: 8, r: 14)
//            .append(txHash)
            .append(from)
            .append(to)
            .append(GSplitPanel().width(.matchParent).withViews(time, price))
            .done()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
