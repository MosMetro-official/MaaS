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
    
    private enum CodingKeys: String, CodingKey {
        case status
        case keyChangeLimit
        case keyChangeLeft
        case reason
        case hashKey
        case type
        case paySystem
        case maskedPan
        case subscription
        case payment
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decodeIfPresent(Status.self, forKey: .status)
        self.keyChangeLimit = try container.decode(Int.self, forKey: .keyChangeLimit)
        self.keyChangeLeft = try container.decode(Int.self, forKey: .keyChangeLeft)
        self.reason = try container.decodeIfPresent(M_Description.self, forKey: .reason)
        self.hashKey = try container.decode(String.self, forKey: .hashKey)
        self.type = try container.decode(String.self, forKey: .type)
        self.paySystem = try container.decodeIfPresent(PaySystem.self, forKey: .paySystem)
        self.maskedPan = try container.decode(String.self, forKey: .maskedPan)
        self.subscription = try container.decodeIfPresent(M_Subscription.self, forKey: .subscription)
        self.payment = try container.decodeIfPresent(M_AuthInfo.self, forKey: .payment)
    }
    
    public static func fetchUserInfo() async throws -> M_UserInfo {
        let client = APIClient.authClient
        let response = try await client.send(.GET(path: "/api/user/v1/info"))
        let userInfo = try JSONDecoder().decode(M_BaseResponse<M_UserInfo>.self, from: response.data).data
        return userInfo
    }
}
