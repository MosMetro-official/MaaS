//
//  MaaSNetworkDelegate.swift
//  MaaS
//
//  Created by Слава Платонов on 10.06.2022.
//

import Foundation

public protocol MaaSNetworkDelegate : AnyObject {
    
    /// Метод необходим для обновления авторизационного токена. Вы должны реализовать его на своей стороне
    /// - Returns: Результат обновления токена
    func refreshToken(completion: @escaping (Bool) -> Void)
}
