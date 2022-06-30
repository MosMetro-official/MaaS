//
//  M_Support.swift
//  MaaS
//
//  Created by Слава Платонов on 24.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_SupportResponse {
    let url: String
    
    init?(data: JSON) {
        self.url = data["data"].stringValue
    }
    
    static func sendSupportRequest(payId: String? = nil, redirectUrl: String, completion: @escaping (Result<M_SupportResponse, APIError>) -> Void) {
        let client = APIClient.authClient
        var query: [String: String] = [:]
        if let payId = payId {
            query.updateValue(payId, forKey: "paymentId")
        }
        query.updateValue(redirectUrl, forKey: "redirectURI")
        client.send(.GET(path: "/api/issues/v1/form", query: query)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let supportResponse = M_SupportResponse(data: json) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(supportResponse))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
