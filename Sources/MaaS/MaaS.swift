import UIKit

public class MaaS {
    
    var bundle: Bundle {
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
    public var token: String? = ""
    
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
