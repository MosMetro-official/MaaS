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
        self.date = data["date"].stringValue
        self.service = data["service"].stringValue
        self.trip = data["trip"].stringValue
        self.amount = data["amount"].intValue
    }
    
    static func getDebtInfo(completion: @escaping (Result<M_DebtInfo, Error>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/user/v1/debt")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard let debtInfo = M_DebtInfo(data: json) else { return }
                completion(.success(debtInfo))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
