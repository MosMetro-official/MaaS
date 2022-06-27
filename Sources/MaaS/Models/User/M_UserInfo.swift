//
//  M_UserInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 15.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

public struct M_UserInfo {
    public let status: Status?
    public let keyChangeLimit: Int
    public let keyChangeLeft: Int
    public let reason: M_Description
    public let hashKey: String
    public let type: String
    public let paySystem: PaySystem?
    public let maskedPan: String
    public let subscription: M_Subscription?
    public let payment: M_AuthInfo?
    
    init?(data: JSON) {
        guard
            let status = data["status"].string,
            let keyChangeLimit = data["keyChangeLimit"].int,
            let keyChangeLeft = data["keyChangeLeft"].int,
            let haskKey = data["hashKey"].string,
            let paySystem = data["paySystem"].string,
            let maskedPan = data["maskedPan"].string else { return nil }
        
        self.status = Status(rawValue: status)
        self.keyChangeLimit = keyChangeLimit
        self.keyChangeLeft = keyChangeLeft
        self.reason = (data["reason"]["ru"].stringValue, data["reason"]["en"].stringValue)
        self.hashKey = haskKey
        self.type = data["type"].stringValue
        self.paySystem = PaySystem(rawValue: paySystem)
        self.maskedPan = maskedPan
        self.subscription = M_Subscription(data: data["subscription"])
        self.payment = M_AuthInfo(data: data["payment"])
    }
    
    public static func fetchUserInfo(completion: @escaping (Result<M_UserInfo, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/user/v1/info")) { result in
            switch result {
            case .success(let resposne):
                let json = JSON(resposne.data)
                guard let userInfo = M_UserInfo(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(userInfo))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
