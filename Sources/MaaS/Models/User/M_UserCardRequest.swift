//
//  M_UserCardRequest.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks


public struct M_UserCardRequest {
    let payData: M_PayData
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        let payDataBody = payData.createRequestBody()
        result.updateValue(payDataBody, forKey: "payData")
        return result
    }
}

public struct M_PayData {
    let tranId: String
    let price: String
    let redirectUrl: M_RedirectUrl
    let paymentMethod: M_PaymentMethod
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        result.updateValue(tranId, forKey: "tranId")
        result.updateValue("", forKey: "price")
        result.updateValue(paymentMethod.rawValue, forKey: "paymentMethod")
        let redirectBody = redirectUrl.createRequsetBody()
        result.updateValue(redirectBody, forKey: "redirectUrl")
        return result
    }
}
