//
//  AuthClient.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation
import MMCoreNetworkCallbacks

extension APIClient {
    public static var authClient: APIClient {
        return APIClient(host: MaaS.host, interceptor: MaaSApiClientInterceptor(), httpProtocol: .HTTPS, configuration: .default)
    }
}

class MaaSApiClientInterceptor: APIClientInterceptor {
    func client(_ client: APIClient, willSendRequest request: inout URLRequest) {
        request.appendAuthHeaders()
    }
    
    func client(_ client: APIClient, initialRequest: Request, didReceiveInvalidResponse response: HTTPURLResponse, data: Data?, completion: @escaping (RetryPolicy) -> Void) {
        if response.statusCode == 401 {
            guard let networkDelegate = MaaS.networkDelegate else {
                fatalError("Вы не реализовали делегат работы с авторизацией")
            }
            networkDelegate.refreshToken { result in

                if result {
                    completion(.shouldRetry)
                    return
                } else {
                    completion(.doNotRetry)
                    return
                }
            }

        } else {
            if let data = data {
                let json = JSON(data)
                print("🥰 ERROR - \(json)")
                let message = json["error"]["message"].stringValue
                completion(.doNotRetryWith(.genericError(message)))
                return
            }
            completion(.doNotRetryWith(.unacceptableStatusCode(response.statusCode)))
            return
        }
    }
}
