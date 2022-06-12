//
//  M_DebtInfo.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

struct M_DebtInfo {
    let date: String
    let service: String
    let trip: String
    let amount: Int
    
    init?(data: JSON) {
        guard
            let date = data["date"].string,
            let service = data["service"].string,
            let trip = data["trip"].string,
            let amount = data["amount"].int else { return nil }
        self.date = date
        self.service = service
        self.trip = trip
        self.amount = amount
    }
    
    static func getDebtInfo(completion: @escaping (Result<M_DebtInfo, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/user/v1/debt")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let debtInfo = M_DebtInfo(data: json["data"]) else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(debtInfo))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
