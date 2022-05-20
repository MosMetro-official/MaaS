import UIKit

public class MaaS {
    
    var bundle: Bundle {
        let podBundle = Bundle(for: type(of: self))
        guard let url = podBundle.url(forResource: "MaaS", withExtension: "bundle") else {
            return podBundle
        }
        return Bundle(url: url) ?? podBundle
    }
    
    public static let shared = MaaS()
    
    public func showMaaSFlow() -> UINavigationController {
        return UINavigationController(rootViewController: M_ChooseSubController())
    }
    
    public static func registerFonts() {
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "MoscowSans-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "MoscowSans-Regular", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "MoscowSans-Medium", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "Comfortaa", fontExtension: "ttf")
    }
}
