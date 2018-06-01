import GaniLib

class DemoBuild: BuildConfig, MyBuildConfig {
    func host() -> String {
        return "https://quicktip-demo.herokuapp.com"
    }
    
    func etherscanHost() -> String {
        return "https://rinkeby.etherscan.io"
    }
}
