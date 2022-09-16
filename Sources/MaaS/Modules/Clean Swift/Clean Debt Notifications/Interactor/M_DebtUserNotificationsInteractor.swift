//
//  M_DebtUserNotificationsInteractor.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import Foundation

protocol M_DebtUserNotificationsBusinessLogic: AnyObject {
    func requestState()
    func requestReloadNotifications()
    func handleNotification(_ notification: M_DebtUserNotificationsModels.Request.Notification)
}

protocol M_DebtUserNotificationDataStore: AnyObject {
    var notifications: [M_MaasDebtNotifification]? { get set }
}

final class M_DebtUserNotificationsInteractor: M_DebtUserNotificationsBusinessLogic, M_DebtUserNotificationDataStore {
    
    var presenter: M_DebtUserNotificationsPresentationLogic?
    var notifications: [M_MaasDebtNotifification]?
    
    init(presenter: M_DebtUserNotificationsPresentationLogic? = nil) {
        self.presenter = presenter
    }
    
    func requestState() {
        guard let notifications = notifications else { return }
        let response = M_DebtUserNotificationsModels.Response.Notifications(notifications: notifications)
        presenter?.prepareViewModel(response)
    }
    
    func handleNotification(_ notification: M_DebtUserNotificationsModels.Request.Notification) {
        requestLoading()
        markUnreadMessage(notification.notification)
        let response = M_DebtUserNotificationsModels.Response.Notification(notification: notification.notification)
        presenter?.prepareSafariController(response)
    }
    
    private func markUnreadMessage(_ notification: M_MaasDebtNotifification) {
        notification.markAsRead { result in
            switch result {
            case .success(let isRead):
                print("MESSAGE READ STATUS - \(isRead)")
                return
            case .failure(let error):
                let response = M_DebtUserNotificationsModels.Response.Error(
                    title: error.errorTitle,
                    descr: error.localizedDescription,
                    notification: notification
                )
                self.presenter?.prepareErrorState(response)
            }
        }
    }
    
    func requestReloadNotifications() {
        requestLoading()
        M_MaasDebtNotifification.fetchDebts { result in
            switch result {
            case .success(let notifications):
                let newNotifications = notifications.filter { $0.read == false }
                let response = M_DebtUserNotificationsModels.Response.Notifications(notifications: newNotifications)
                self.presenter?.prepareViewModel(response)
            case .failure(let error):
                let response = M_DebtUserNotificationsModels.Response.Error(
                    title: error.errorTitle,
                    descr: error.localizedDescription,
                    notification: nil
                )
                self.presenter?.prepareErrorState(response)
            }
        }
    }
    
    private func requestLoading() {
        let response = M_DebtUserNotificationsModels.Response.Loading(title: "Загрузка...", descr: "Немного подождите")
        presenter?.prepareLoadingState(response)
    }
}
