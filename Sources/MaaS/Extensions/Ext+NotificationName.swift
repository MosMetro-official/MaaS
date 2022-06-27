//
//  Ext+NotificationName.swift
//  MaaS
//
//  Created by Слава Платонов on 14.06.2022.
//

import Foundation

public extension Notification.Name {
    static let maasPaymentSuccess = Notification.Name("maasPaymentSuccess")
    static let maasPaymentDeclined = Notification.Name("maasPaymentDeclined")
    static let maasPaymentCanceled = Notification.Name("maasPaymentCanceled")
    static let maasChangeCardSucceed = Notification.Name("maasChangeCardSuccess")
    static let maasChangeCardDeclined = Notification.Name("maasChangeCardDeclined")
    static let maasChangeCardCanceled = Notification.Name("maasChangeCardCanceled")
    static let maasUpdateUserInfo = Notification.Name("maasUpdateUserInfo")
    static let maasSupportForm = Notification.Name("maasSupportForm")
}
