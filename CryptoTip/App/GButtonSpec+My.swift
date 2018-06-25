import GaniLib

extension GButtonSpec {
    static let primary = GButtonSpec() { view in
        view
            .color(bg: UIColor(hex: "#a49595"))
            .border(color: UIColor(hex: "#a49595"))
            .done()
    }
    
    static let standard = GButtonSpec() { view in
        view
            .color(bg: nil, text: UIColor(hex: "#6a5555"))
            .border(color: UIColor(hex: "#6a5555"))
            .paddings(t: 8, l: 14, b: 8, r: 14)
            .font(nil, size: 14)
            .done()
    }
}

