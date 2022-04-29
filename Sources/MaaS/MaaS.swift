import UIKit
public let fontBundle = Bundle.module
public class MaaS {
    
    public static let shared = MaaS()
    
    public func showMaaSFlow() -> UINavigationController {
        return UINavigationController(rootViewController: M_ChooseSubController())
    }
    
    public static func registerFonts() {
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Regular", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "MoscowSans-Medium", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: .module, fontName: "Comfortaa", fontExtension: "ttf")
    }
}
