//
//  M_UserInfoResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 15.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_UserInfoResponse {
    let status: String
    let keyChangeLimit: Int
    let keyChangeLeft: Int
    let reason: M_Description?
    let hashKey: String
    let type: String
    let paySystem: String
    let maskedPan: String
    
    init?(data: JSON) {
        guard
            let status = data["status"].string,
            let keyChangeLimit = data["keyChangeLimit"].int,
            let keyChangeLeft = data["keyChangeLeft"].int,
            let haskKey = data["hashKey"].string,
            let paySystem = data["paySystem"].string,
            let maskedPan = data["maskedPan"].string else { return nil }
        
        self.status = status
        self.keyChangeLimit = keyChangeLimit
        self.keyChangeLeft = keyChangeLeft
        self.reason = M_Description(data: data["reason"])
        self.hashKey = haskKey
        self.type = data["type"].stringValue
        self.paySystem = paySystem
        self.maskedPan = maskedPan
    }
    
    static func fetchShortUserInfo(completion: @escaping (Result<M_UserInfoResponse, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/user/v1/info")) { result in
            switch result {
            case .success(let resposne):
                let json = JSON(resposne.data)
                guard let showUserInfo = M_UserInfoResponse(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(showUserInfo))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
