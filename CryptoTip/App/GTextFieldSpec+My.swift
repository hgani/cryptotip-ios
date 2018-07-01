import GaniLib

extension GTextFieldSpec {
    static let standard = GTextFieldSpec() { view in
        _ = view.border(style: .roundedRect)
    }
}

