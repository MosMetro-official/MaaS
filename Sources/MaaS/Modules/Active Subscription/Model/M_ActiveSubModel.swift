//
//  M_ActiveSubModel.swift
//  MaaS
//
//  Created by Слава Платонов on 24.06.2022.
//

import Foundation

typealias Debet = (hasDebet: Bool, totalDebet: Int)

public struct M_ActiveSubModel {
    
    var userInfo: M_UserInfo?
    var debitsNotifications: [M_MaasDebtNotifification]?
    var newMaskedPan: String?
    var oldMaskedPan: String?
    var notification: M_MaasDebtNotifification?
    
    var needReloadCard: Bool {
        newMaskedPan == oldMaskedPan
    }
    
    var sortedNotifications: [M_MaasDebtNotifification] {
        guard let notifications = debitsNotifications else { return [] }
        let sorted = notifications.sorted {
            guard $0.date != nil, $1.date != nil else { return false }
            return $0.date! > $1.date!
        }
        return sorted
    }
    
    init(userInfo: M_UserInfo? = nil) {
        self.userInfo = userInfo
    }
    
    public mutating func findUnreadMessages() -> Bool {
        var result = false
        sortedNotifications.forEach { notification in
            if !notification.read {
                self.notification = notification
                result = true
            }
        }
        return result
    }
}
