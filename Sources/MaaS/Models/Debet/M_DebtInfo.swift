//
//  M_DebtInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_DebtInfo: Codable {
    let date: String
    let service: String
    let trip: String
    let amount: Int
    
    static func fetchDebtInfo() async throws -> [M_DebtInfo] {
        let client = APIClient.authClient
        let response = try await client.send(.GET(path: "/api/user/v1/debt"))
        let debts = try JSONDecoder().decode(M_BaseResponse<[M_DebtInfo]>.self, from: response.data).data
        return debts
    }
}
