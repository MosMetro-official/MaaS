//
//  M_UserKeyResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks


struct M_UserKeyRequest {
    let payData: M_PayData
    
    func createRequestBody() -> [String: Any] {
        var result = [String: Any]()
        let payDataBody = payData.createRequestBody()
        result.updateValue(payDataBody, forKey: "payData")
        return result
    }
}

struct M_PayData {
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


struct M_UserKeyResponse {
    let paymentId: String
    let payment: M_PaymentInfo?
    
    init?(data: JSON) {
        self.paymentId = data["paymentId"].stringValue
        self.payment = M_PaymentInfo(data: data["payment"])
    }
    
    static func changeUserCardKey(body: [String: Any], completion: @escaping (Result<M_UserKeyResponse, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.POST(path: "/api/user/v1/key", body: body, contentType: .json)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let userKey = M_UserKeyResponse(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(userKey))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
