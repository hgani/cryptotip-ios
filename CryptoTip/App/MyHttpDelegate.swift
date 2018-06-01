import GaniLib

class MyHttpDelegate : GHttpDelegate {
    func restParams(from params: GParams, method: HttpMethod) -> GParams {
//        var dupParams = params
//        if let csrfToken = Session.instance.csrfToken {
//            switch method {
//            case .post, .patch, .delete:
//                dupParams["authenticity_token"] = csrfToken
//            default:
//                GLog.d("Don't pass token for other methods")
//            }
//        }
//        return dupParams
        return params;
    }
    
    func processResponse(_ response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
//        case 401, 422:  // unauthorized and invalid csrf
//            Session.instance.destroy()
//
//            if response.url?.path == type(of: self).loginPath {
//                // Avoid reopening another login screen when login attempt fails (which will also return 401)
//                return true
//            }
//
//            if let navController = GApp.instance.navigationController {
//                navController.popToRootViewController(animated: false)
//                navController.pushViewController(SigninScreen(), animated: true)
//            }
//            return false
        default:
            return true
        }
    }
}
