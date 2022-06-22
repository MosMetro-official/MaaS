//
//  M_UserCardResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 20.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

public struct M_UserCardResponse {
    let paymentId: String
    let payment: M_PaymentInfo?
    
    init?(data: JSON) {
        self.paymentId = data["paymentId"].stringValue
        self.payment = M_PaymentInfo(data: data["payment"])
    }
    
    static func sendRequsetToChangeUserCard(body: [String: Any], completion: @escaping (Result<M_UserCardResponse, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.POST(path: "/api/user/v1/key", body: body, contentType: .json)) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let userCard = M_UserCardResponse(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(userCard))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
