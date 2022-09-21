//
//  M_DebtNotifification.swift
//  Pods
//
//  Created by polykuzin on 19/07/2022.
//

import Foundation
import MMCoreNetworkAsync

struct M_MaasDebtNotifification: Codable {
    let id : String
    let url : String
    let read : Bool
    let date : Date?
    let message : MaasMessage?
    
    init() {
        id = "id"
        url = "url"
        read = true
        date = nil
        message = nil
    }
    
    func markAsRead() async throws -> Bool {
        let client = APIClient.authClient
        let response = try await client.send(.PUT(path: "/api/user/v1/messages/\(self.id)"))
        let result = try JSONDecoder().decode(Bool.self, from: response.data)
        return result
    }
    
    public static func fetchDebts() async throws -> [M_MaasDebtNotifification] {
        let client = APIClient.authClient
        let response = try await client.send(.GET(path: "/api/user/v1/messages"))
        let notifications = try JSONDecoder().decode([M_MaasDebtNotifification].self, from: response.data)
        return notifications
    }
}

public struct MaasMessage: Codable {
    let title : String
    let subtitle : String
}
