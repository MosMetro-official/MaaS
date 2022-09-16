//
//  M_ModalDebetNotificationController.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView
import SafariServices

public class M_ModalDebetNotificationController: UIViewController {
    
    private let nestedView = M_ModalDebtNotificationView.loadFromNib()
    
    var debtNotification: M_MaasDebtNotifification? {
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
        
    }
    
    private func handleUrl(url: String) {
        guard let url = URL(string: url) else { return }
        let sv = SFSafariViewController(url: url)
        sv.delegate = self
        DispatchQueue.main.async {
            self.present(sv, animated: true)
        }
    }
    
    private func showLoading() {
        let loading = M_ModalDebtNotificationView.ViewState.Loading(
            title: "Загрузка...",
            descr: "Немного подождите"
        )
        nestedView.viewState = .init(
            dataState: .loading(loading),
            onMore: Command {},
            debtText: "",
            titleText: "",
            buttonTitle: ""
        )
    }
    
    private func showError(with title: String, descr: String, onRetry: Command<Void>) {
        let onClose = Command {
            self.dismiss(animated: true)
        }
        let error = M_ModalDebtNotificationView.ViewState.Error(
            title: title,
            descr: descr,
            onRetry: onRetry,
            onClose: onClose
        )
        nestedView.viewState = .init(
            dataState: .error(error),
            onMore: Command {},
            debtText: "",
            titleText: "",
            buttonTitle: ""
        )
    }
    
    private func readMessage() {
        debtNotification?.markAsRead(completion: { result in
            switch result {
            case .success(let isRead):
                print("MESSAGE READ STATUS - \(isRead)")
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.makeState()
                }
                self.showError(
                    with: error.errorTitle,
                    descr: error.errorSubtitle,
                    onRetry: onRetry
                )
            }
        })
    }
    
    private func makeState() {
        guard let message = debtNotification?.message else {
            self.dismiss(animated: true)
            return
        }

        let onMore = Command { [weak self] in
            guard let self = self else { return }
            if let url = self.debtNotification?.url {
                self.showLoading()
                self.readMessage()
                self.handleUrl(url: url)
            } else {
                self.dismiss(animated: true)
            }
        }
        
        let viewState: M_ModalDebtNotificationView.ViewState = .init(
            dataState: .loaded,
            onMore: onMore,
            debtText: message.subtitle,
            titleText: message.title,
            buttonTitle: debtNotification?.url != nil ? "Подробнее" : "Закрыть"
        )
    }
}

extension M_ModalDebetNotificationController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.dismiss(animated: true)
    }
}
