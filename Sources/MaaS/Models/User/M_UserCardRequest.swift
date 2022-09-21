//
//  M_UserCardRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import Foundation
import MMCoreNetworkAsync


public struct M_UserCardRequest: Codable {
    let payData: M_PayData
    
//    func createRequestBody() -> [String: Any] {
//        var result = [String: Any]()
//        let payDataBody = payData.createRequestBody()
//        result.updateValue(payDataBody, forKey: "payData")
//        return result
//    }
}

public struct M_PayData: Codable {
    let redirectUrl: M_RedirectUrl
    let paymentMethod: M_PaymentMethod
    
    private enum CodingKeys: String, CodingKey {
        case redirectUrl
        case paymentMethod
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: M_PayData.CodingKeys.self)
        redirectUrl = try values.decode(M_RedirectUrl.self, forKey: .redirectUrl)
        paymentMethod = try values.decode(M_PaymentMethod.self, forKey: .paymentMethod)
    }
    
    public init(redirectUrl: M_RedirectUrl, paymentMethod: M_PaymentMethod) {
        self.redirectUrl = redirectUrl
        self.paymentMethod = paymentMethod
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(redirectUrl, forKey: .redirectUrl)
        try container.encode(paymentMethod, forKey: .paymentMethod)
    }
    
//    func createRequestBody() -> [String: Any] {
//        var result = [String: Any]()
//        result.updateValue(paymentMethod.rawValue, forKey: "paymentMethod")
//        let redirectBody = redirectUrl.createRequsetBody()
//        result.updateValue(redirectBody, forKey: "redirectUrl")
//        return result
//    }
}
