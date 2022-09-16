//
//  M_DebtNotifification.swift
//  Pods
//
//  Created by polykuzin on 19/07/2022.
//

import MMCoreNetworkCallbacks

public struct M_MaasDebtNotifification {
    let id : String
    let url : String
    let read : Bool
    let date : Date?
    let message : MaasMessage?
    
    init?(data: JSON) {
        self.id = data["id"].stringValue
        self.url = data["url"].stringValue
        self.read = data["read"].boolValue
        self.date = data["date"].stringValue.converToDate()
        self.message = MaasMessage(data: data["message"])
    }
    
    func markAsRead(completion: @escaping (Result<Bool, APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.PUT(path: "/api/user/v1/messages/\(self.id)")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard
                    let array = json["data"].array
                else {
                    completion(.failure(.badMapping))
                    return
                }
                completion(.success(true))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    public static func fetchDebts(completion: @escaping (Result<[M_MaasDebtNotifification], APIError>) -> Void) {
        let client = APIClient.authClient
        client.send(.GET(path: "/api/user/v1/messages")) { result in
            switch result {
            case .success(let response):
                let json = JSON(response.data)
                guard
                    let array = json["data"].array
                else {
                    completion(.failure(.badMapping))
                    return
                }
                let notifications = array.compactMap { M_MaasDebtNotifification(data: $0) }
                completion(.success(notifications))
                return
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
}

public struct MaasMessage {
    let title : String
    let subtitle : String
    
    init?(data: JSON) {
        self.title = data["title"].stringValue
        self.subtitle = data["subtitle"].stringValue
    }
}
