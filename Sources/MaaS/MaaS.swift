import UIKit

public class MaaS {
    
    public enum RedirectUrls: String {
        case succeedUrl = "maasexample://main/maasPaymentSuccess"
        case declinedUrl = "maasexample://main/maasPaymentDeclined"
        case canceledUrl = "maasexample://main/maasPaymentCanceled"
        case succeedUrlCard = "maasexample://main/maasChangeCardSuccess"
        case declinedUrlCard = "maasexample://main/maasChangeCardDeclined"
        case canceledUrlCard = "maasexample://main/maasChangeCardCanceled"
    }
    
    internal var bundle: Bundle {
        let podBundle = Bundle(for: type(of: self))
        guard let url = podBundle.url(forResource: "MaaS", withExtension: "bundle") else {
            return podBundle
        }
        return Bundle(url: url) ?? podBundle
    }
    
    public var host: String = "maas.brndev.ru"
    public var applicationName: String = ""
    public var language: String = "ru_RU"
    public weak var networkDelegate: MaaSNetworkDelegate?
    public var token: String? = "LhvbsT6vFy_YR7iz4DHVgk77zh5Hv9OgSrIo-Lu29Uk"
    public var userHasSub: Bool!
    public var currentSub: M_CurrentSubInfo?
    
    public static let shared = MaaS()
    
    public func showMaaSFlow(completion: @escaping (UIViewController) -> Void) {
        var flow: UIViewController = UIViewController()
        let chooseSubFlow = M_ChooseSubController()
        let activeSubFlow = M_ActiveSubController()
        getUserSubStatus {
            DispatchQueue.main.async {
                activeSubFlow.currentSub = self.currentSub
                flow = self.userHasSub ? activeSubFlow : chooseSubFlow
                completion(flow)
            }
        }
    }
    
    public static func registerFonts() {
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "MoscowSans-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "MoscowSans-Regular", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "MoscowSans-Medium", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.shared.bundle, fontName: "Comfortaa", fontExtension: "ttf")
    }
    
    public func getUserSubStatus(completion: @escaping () -> Void) {
        M_CurrentSubInfo.getCurrentStatusOfUser { result in
            switch result {
            case .success(let currentSub):
                self.userHasSub = currentSub.subscription.id != ""
                self.currentSub = currentSub
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    internal var deviceOS : String {
        return UIDevice.current.systemVersion
    }
    
    internal var deviceUUID : String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    internal var deviceAppVersion : String? {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return nil
        }
        return "\(version) (\(build))"
    }
    
    internal var deviceModel: String {
        return UIDevice.modelName
    }
    
    internal var deviceBundleSignature : String? {
        guard let infoPlistUrl = Bundle.main.url(forResource: "Info", withExtension: "plist") else {
            return nil
        }
        var signature = "00000000"
        do {
            let plistFile = try FileHandle(forReadingFrom: infoPlistUrl)
            let fileData = plistFile.readDataToEndOfFile()
            let dataLength = fileData.count
            fileData.withUnsafeBytes { ptr in
                guard
                    let bytes = ptr.baseAddress?.assumingMemoryBound(to: Int8.self)
                else { return }
                var crc = 0
                for i in 0..<dataLength {
                    crc ^= Int(bytes[i])
                    for _ in 0..<8 {
                        var b = 0
                        
                        if crc == 1 {
                            b = 0xd5828281
                        }
                        crc = ((crc>>1) & 0x7fffffff) ^ b
                    }
                    crc ^= 0xd202ef8d
                }
                signature = String(format: "%08X", crc)
            }
        } catch(let error) {
            print("Read Info.plist failed with error: \(error)")
            return nil
        }
        return signature
    }
    
    internal var deviceUserAgent: String {
        let defaultUserAgent = String(format: "Mozilla/5.0 (iPhone; CPU iPhone OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1", self.deviceOS)
        
        if #available(iOS 13, *) {
            guard let appVersion = self.deviceAppVersion,
                  let bundleSignature = self.deviceBundleSignature else {
                return defaultUserAgent
            }
            
            return String(format: "\(self.applicationName)/%@ (iOS; %@; %@; %@)", appVersion, self.deviceModel, self.deviceOS, bundleSignature)
        } else {
            return defaultUserAgent
        }
    }
}
