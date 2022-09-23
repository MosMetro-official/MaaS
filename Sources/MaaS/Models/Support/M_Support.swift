//
//  M_Support.swift
//  MaaS
//
//  Created by Слава Платонов on 24.06.2022.
//

import Foundation
import MMCoreNetworkAsync

struct M_SupportResponse: Codable {
    let url: String
    
    static func sendSupportRequest(payId: String? = nil, redirectUri: String) async throws -> M_SupportResponse {
        let client = APIClient.authClient
        var query: [String: String] = [:]
        if let payId = payId {
            query.updateValue(payId, forKey: "paymentId")
        }
        query.updateValue(redirectUri, forKey: "redirectURI")
        let response = try await client.send(.GET(path: "/api/issues/v1/form", query: query))
        let support = try JSONDecoder().decode(M_BaseResponse<M_SupportResponse>.self, from: response.data).data
        return support
    }
}
