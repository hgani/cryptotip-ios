import GaniLib

class ProductionBuild: BuildConfig {
    func host() -> String {
        return "https://quicktip-production.herokuapp.com"
    }
}
