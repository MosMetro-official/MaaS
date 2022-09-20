//
//  M_DebtUserNotificationsPresenter.swift
//  Pods
//
//  Created by Слава Платонов on 08.09.2022.
//

import CoreTableView

protocol M_DebtUserNotificationsPresentationLogic: AnyObject {
    func prepareViewModel(_ response: M_DebtUserNotificationsModels.Response.Notifications)
    func prepareLoadingState(_ response: M_DebtUserNotificationsModels.Response.Loading)
    func prepareErrorState(_ response: M_DebtUserNotificationsModels.Response.Error)
    func prepareSafariController(_ response: M_DebtUserNotificationsModels.Response.Notification)
}

final class M_DebtUserNotificationsPresenter: M_DebtUserNotificationsPresentationLogic {
    
    weak var controller: M_DebtUserNotificationsDisplayLogic?
    
    init(controller: M_DebtUserNotificationsDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareViewModel(_ response: M_DebtUserNotificationsModels.Response.Notifications) {
        let states = makeState(from: response)
        let viewState = M_DebtNotificationsView.ViewState(state: states, dataState: .loaded)
        let viewModel = M_DebtUserNotificationsModels.ViewModel(viewState: viewState)
        controller?.displayNotifications(viewModel)
    }
    
    func prepareLoadingState(_ response: M_DebtUserNotificationsModels.Response.Loading) {
        let loading = M_DebtNotificationsView.ViewState.Loading(title: response.title, descr: response.descr)
        let viewState = M_DebtNotificationsView.ViewState(state: [], dataState: .loading(loading))
        let viewModel = M_DebtUserNotificationsModels.ViewModel(viewState: viewState)
        controller?.displayNotifications(viewModel)
    }
    
    func prepareErrorState(_ response: M_DebtUserNotificationsModels.Response.Error) {
        let onRetry = Command { [weak self] in
            if let notification = response.notification {
                self?.controller?.handleNotification(notification)
            }
        }
        let onClose = Command { [weak self] in
            self?.controller?.popViewController()
        }
        let error = M_DebtNotificationsView.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onRetry: onRetry,
            onClose: onClose
        )
        let viewState = M_DebtNotificationsView.ViewState(state: [], dataState: .error(error))
        let viewModel = M_DebtUserNotificationsModels.ViewModel(viewState: viewState)
        controller?.displayNotifications(viewModel)
    }
    
    func prepareSafariController(_ response: M_DebtUserNotificationsModels.Response.Notification) {
        guard let url = URL(string: response.notification.url) else { return }
        controller?.displaySafariController(url)
    }
    
    private func makeState(from response: M_DebtUserNotificationsModels.Response.Notifications) -> [State] {
        var states: [State] = []
        let headerTitleHeight = "Здесь мы покажем важные уведомления о вашей подписке".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 80,
            font: Appearance.getFont(.smallBody)
        )
        let header = M_DebtNotificationsView.ViewState.Header(id: "notifications", height: headerTitleHeight + 50 + 62 + 20)
        response.notifications.forEach { notification in
            if let message = notification.message {
                let title = message.title
                let descr = message.subtitle
                let titleHeight = title.height(
                    withConstrainedWidth: UIScreen.main.bounds.width - 48,
                    font: Appearance.getFont(.smallBody)
                )
                let descrHeight = descr.height(
                    withConstrainedWidth: UIScreen.main.bounds.width - 48,
                    font: Appearance.getFont(.card)
                )
                let onNotification = Command {
                    self.controller?.handleNotification(notification)
                }
                let notification = M_DebtNotificationsView.ViewState.Notification(
                    id: notification.id,
                    title: title,
                    descr: descr,
                    onItemSelect: onNotification,
                    height: titleHeight + descrHeight + 30 + 8
                ).toElement()
                let state = State(model: .init(id: "notification", header: nil, footer: nil), elements: [notification])
                states.append(state)
            }
        }
        if states.isEmpty {
            let emptyNotification = M_DebtNotificationsView.ViewState.Notification(id: "emptyNotif", title: "Все хорошо", descr: "Новых уведомлений нет", onItemSelect: Command {}, height: 100).toElement()
            let state = State(model: .init(id: "empty", header: header, footer: nil), elements: [emptyNotification])
            states.append(state)
        } else {
            states[0].model = .init(id: "notification", header: header, footer: nil)
        }
        return states
    }
}
