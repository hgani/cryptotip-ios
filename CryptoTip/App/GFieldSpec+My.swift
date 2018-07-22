import GaniLib

extension GTextFieldSpec {
    static let standard = GTextFieldSpec() { view in
        _ = view.border(color: .lightGray)
    }
}

extension GTextViewSpec {
    static let standard = GTextViewSpec() { view in
        _ = view.border(color: .lightGray)
    }
}
