//
//  M_UserCardResponse.swift
//  MaaS
//
//  Created by Слава Платонов on 20.06.2022.
//

import Foundation
import MMCoreNetworkAsync

public struct M_UserCardResponse: Codable {
    let paymentId: String
    let payment: M_PaymentInfo?
    
    static func sendRequsetToChangeUserCard(body: M_UserCardRequest) async throws -> M_UserCardResponse {
        let client = APIClient.authClient
        let response = try await client.send(.POST(path: "/api/user/v1/key", body: body, contentType: .json))
        let cardResponse = try JSONDecoder().decode(M_BaseResponse<M_UserCardResponse>.self, from: response.data).data
        return cardResponse
    }
}
