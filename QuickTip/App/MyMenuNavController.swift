import GaniLib

class MyMenuNavController: MenuNavController {
    override func initMenu(_ menu: Menu) {
        menu.add(MenuItem(title: "Receive").icon("fa:shoppingbag").screen(ReceiveScreen()))
        menu.add(MenuItem(title: "Send").icon("fa:flag").screen(SendScreen()))
        menu.add(MenuItem(title: "Transactions").icon("fa:calendar").screen(TransactionListScreen()))
    }
}

//class HeaderCell: MenuCell {
//    override func populate() {
//        _ = title.font(nil, size: 14)
//
//        self
//            .color(bg: UIColor(hex: "#ededed"))
//            .append(GHorizontalPanel().paddings(t: 0, l: 0, b: 0, r: 0).append(title, left: 5))
//            .end()
//    }
//}

