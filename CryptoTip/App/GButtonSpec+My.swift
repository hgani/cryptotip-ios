import GaniLib

extension GButtonSpec {
    static let primary = GButtonSpec() { view in
        view
            .color(bg: UIColor(hex: "#a49595"))
            .border(color: UIColor(hex: "#6a5555"))
            .done()
    }
}

