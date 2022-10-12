//
//  M_UserInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 15.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_UserInfo: Codable {
    public let status: Status?
    public let keyChangeLimit: Int
    public let keyChangeLeft: Int
    public let reason: M_Description?
    public let hashKey: String
    public let type: String
    public let paySystem: PaySystem?
    public let maskedPan: String
    public let subscription: M_Subscription?
    public let payment: M_AuthInfo?
    
    static var hasSeenOnboarding: Bool {
        return UserDefaults.standard.bool(forKey: "maasOnboarding")
    }
    
    public static func fetchUserInfo() async throws -> M_UserInfo {
        let client = APIClient.authClient
        let response = try await client.send(.GET(path: "/api/user/v1/info"))
        let userInfo = try JSONDecoder().decode(M_BaseResponse<M_UserInfo>.self, from: response.data).data
        return userInfo
    }
}

public struct M_SalesIsEnable: Codable {
    let success: Bool
    let data: Bool
    
    public static func fetchSalesIsEnable() async throws -> Bool {
        let client = APIClient.authClient
        let response: M_SalesIsEnable = try await client.send(.GET(path: "/api/subscription/v1/is-enabled")).value
        return response.data
    }
}

