import GaniLib

extension GLabelSpec {
    static let p = GLabelSpec() { label in
        _ = label.font(nil, size: 14)
    }
    static let h1 = GLabelSpec() { label in
        _ = label.font(nil, size: 18, traits: .traitBold)
    }
    static let h2 = GLabelSpec() { label in
        _ = label.font(nil, size: 16, traits: .traitBold)
    }
    static let h3 = GLabelSpec() { label in
        _ = label.font(nil, size: 14, traits: .traitBold)
    }
    static let a = GLabelSpec() { label in
        _ = label.font(nil, size: 14).color(.init(hex: "#334e9c"))
    }
    static let small = GLabelSpec() { label in
        _ = label.font(nil, size: 12)
    }
    static let danger = GLabelSpec() { label in
        _ = label.color(bg: nil, text: .red)
    }
}

