import GaniLib

class DevelopmentBuild: BuildConfig {
    func host() -> String {
        return "http://localhost:4000"
    }
}
