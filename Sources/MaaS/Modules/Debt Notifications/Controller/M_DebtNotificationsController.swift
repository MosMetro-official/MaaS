//
//  M_DebtNotificationsController.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView
import SafariServices

public class M_DebtNotificationsController: UIViewController {
    
    private let nestedView = M_DebtNotificationsView.loadFromNib()
    
    var debetNotifications: [M_MaasDebtNotifification]? {
        didSet {
            makeState()
        }
    }
    
    public override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        makeState()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "Уведомления"
    }
    
    private func makeState() {
        var states: [State] = []
        let headerTitleHeight = "Здесь мы покажем важные уведомления о вашей подписке".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 80,
            font: Appearance.getFont(.smallBody)
        )
        let header = M_DebtNotificationsView.ViewState.Header(id: "notifications", height: headerTitleHeight + 50 + 62 + 20)
        guard let notifications = debetNotifications else { return }
        notifications.forEach { notification in
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
                let onNotification = Command { [weak self] in
                    if let url = URL(string: notification.url) {
                        self?.markUnreadMessage(notification)
                        self?.handleUrl(url: url)
                    } else {
                        return
                    }
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
        let viewState: M_DebtNotificationsView.ViewState = .init(state: states, dataState: .loaded)
        nestedView.viewState = viewState
    }
    
    private func handleUrl(url: URL) {
        let sv = SFSafariViewController(url: url)
        sv.delegate = self
        DispatchQueue.main.async {
            self.present(sv, animated: true)
        }
    }
    
    private func markUnreadMessage(_ notification: M_MaasDebtNotifification) {
        notification.markAsRead { result in
            switch result {
            case .success(let isRead):
                print("MESSAGE READ STATUS - \(isRead)")
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.reloadNotifications()
                }
                self.showError(with: "Произошла ошибка 🥲", and: error.errorSubtitle, onRetry: onRetry)
            }
        }
    }
    
    private func showLoading() {
        let loadingState = M_DebtNotificationsView.ViewState.Loading(
            title: "Загрузка...",
            descr: "Подождите немного"
        )
        nestedView.viewState = .init(state: [], dataState: .loading(loadingState))
    }
    
    private func showError(with title: String, and descr: String, onRetry: Command<Void>) {
        let onClose = Command { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        let errorState = M_DebtNotificationsView.ViewState.Error(
            title: title,
            descr: descr,
            onRetry: onRetry,
            onClose: onClose
        )
        nestedView.viewState = .init(state: [], dataState: .error(errorState))
    }
    
    private func reloadNotifications() {
        showLoading()
        M_MaasDebtNotifification.fetchDebts { result in
            switch result {
            case .success(let notifications):
                let newNotifications = notifications.filter { $0.read == false }
                self.debetNotifications = newNotifications
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.reloadNotifications()
                }
                self.showError(with: "Произошла ошибка 🥲", and: error.errorSubtitle, onRetry: onRetry)
            }
        }
    }
}

extension M_DebtNotificationsController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        reloadNotifications()
    }
}
