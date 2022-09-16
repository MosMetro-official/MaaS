import UIKit
import MMCoreNetworkCallbacks

public class MaaS {
    
    static var bundle: Bundle {
        let podBundle = Bundle(for: self)
        guard let url = podBundle.url(forResource: "MaaS", withExtension: "bundle") else {
            return podBundle
        }
        return Bundle(url: url) ?? podBundle
    }
    
    public static var host: String = "maas.mosmetro.tech"
//    public static var host: String = "maas.brndev.ru"
    
    static var applicationName: String = ""
    
    static var language: String = "ru_RU"
    
    public static weak var networkDelegate: MaaSNetworkDelegate?
    
    public static var token: String? = "JIc1sBwvI6UtzFLZTYPofeYtsrnqACZJDIxYF5Ahk0I"
    
    public static var succeedUrl = "maasexample://main/maasPaymentSuccess"
    public static var declinedUrl = "maasexample://main/maasPaymentDeclined"
    public static var canceledUrl = "maasexample://main/maasPaymentCanceled"
    public static var succeedUrlCard = "maasexample://main/maasChangeCardSuccess"
    public static var declinedUrlCard = "maasexample://main/maasChangeCardDeclined"
    public static var canceledUrlCard = "maasexample://main/maasChangeCardCanceled"
    public static var supportForm = "maasexample://main/maasSupportForm"
    
    public init() { }
        
    
    public func showActiveFlow() -> UIViewController {
        let active = M_ActiveSubController()
        return active
    }
    
    public func showChooseFlow() -> UIViewController {
        let choose = M_ChooseSubController()
        return choose
    }
    
    public static func registerFonts() {
        _ = UIFont.registerFont(bundle: MaaS.bundle, fontName: "MoscowSans-Bold", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.bundle, fontName: "MoscowSans-Regular", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.bundle, fontName: "MoscowSans-Medium", fontExtension: "otf")
        _ = UIFont.registerFont(bundle: MaaS.bundle, fontName: "Comfortaa", fontExtension: "ttf")
    }
    
    public func getUserInfo(completion: @escaping (M_UserInfo?, APIError?) -> Void) {
        M_UserInfo.fetchUserInfo { result in
            switch result {
            case .success(let currentUser):
                completion(currentUser, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    static var deviceOS : String {
        return UIDevice.current.systemVersion
    }
    
    static var deviceUUID : String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var deviceAppVersion : String? {
        guard let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
              let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String else {
            return nil
        }
        return "\(version) (\(build))"
    }
    
    static var deviceModel: String {
        return UIDevice.modelName
    }
    
    static var deviceBundleSignature : String? {
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
    
    static var deviceUserAgent: String {
        let defaultUserAgent = String(format: "Mozilla/5.0 (iPhone; CPU iPhone OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1", deviceOS)
        
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
