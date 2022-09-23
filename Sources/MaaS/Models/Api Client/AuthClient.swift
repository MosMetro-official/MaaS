//
//  AuthClient.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation
import MMCoreNetworkAsync

extension APIClient {
    public static var authClient: APIClient {
        return APIClient(host: MaaS.host, interceptor: MaaSApiClientInterceptor(), httpProtocol: .HTTPS, configuration: .default, serializer: nil, debug: true)
    }
}

class MaaSApiClientInterceptor: APIClientInterceptor {
    func client(_ client: APIClient, willSendRequest request: inout URLRequest) {
        request.appendAuthHeaders()
    }
    
    func client(_ client: APIClient, initialRequest: Request, didReceiveInvalidResponse response: HTTPURLResponse, data: Data?) async -> RetryPolicy {
        if response.statusCode == 401 {
            guard let networkDelegate = MaaS.networkDelegate else {
                fatalError("Не реализован механизм обновления токена")
            }
            do {
                try await networkDelegate.refreshToken()
                return .shouldRetry
            } catch {
                print("🥲🥲🥲 ERROR: \(error)")
                return .doNotRetryWith(.badRequest)
            }
        }
        let error = String(data: data ?? Data(), encoding: .utf8)
        print(error ?? "Auth error")
        return .doNotRetry
    }
}
