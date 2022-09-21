//
//  M_ActiveSubInteractor.swift
//  MaaS
//
//  Created by Слава Платонов on 01.08.2022.
//

import CoreTableView

protocol M_ActiveSubBusinessLogic: AnyObject {
    func fetchUserInfo()
    func fetchSupportUrl()
    func checkCardUpdates()
}

protocol M_ActiveDataStore: AnyObject {
    var userInfo: M_UserInfo? { get set }
    var notifications: [M_MaasDebtNotifification]? { get set }
    var maskedPan: String? { get set }
}

final class M_ActiveSubInteractor: M_ActiveSubBusinessLogic, M_ActiveDataStore {
    
    var presenter: M_ActiveSubPresentationLogic?
    var userInfo: M_UserInfo?
    var notifications: [M_MaasDebtNotifification]?
    var maskedPan: String? {
        didSet {
            model.oldMaskedPan = maskedPan
        }
    }
    
    private var model = M_ActiveSubModels.Response.UserInfo()
    private var count = 0
    
    init(presenter: M_ActiveSubPresentationLogic? = nil) {
        self.presenter = presenter
    }
    
    func fetchUserInfo() {
        showLoading()
        Task {
            do {
                let notifications = try await M_MaasDebtNotifification.fetchDebts()
                let userInfo = try await M_UserInfo.fetchUserInfo()
                model.debtNotifications = notifications
                model.user = userInfo
                handleNotification()
                presenter?.prepareResultState(model)
            } catch {
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.localizedDescription,
                    isCardError: false
                )
                presenter?.prepareError(response)
            }
        }
    }
    
    func checkCardUpdates() {
        Task {
            do {
                let userInfo = try await M_UserInfo.fetchUserInfo()
                model.newMaskedPan = userInfo.maskedPan
                if model.needReloadCard, self.count <= 5 {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        self.count += 1
                        self.checkCardUpdates()
                    }
                }
                self.count = 0
                presenter?.prepareResultState(model)
            } catch {
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.localizedDescription,
                    isCardError: true
                )
                presenter?.prepareError(response)
            }
        }
    }
    
    func fetchSupportUrl() {
        showLoading()
        Task {
            do {
                let support = try await M_SupportResponse.sendSupportRequest(redirectUri: MaaS.supportForm)
                let response = M_ActiveSubModels.Response.SupportForm(url: support.url)
                presenter?.prepareSupportForm(response)
            } catch {
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.localizedDescription,
                    isCardError: false
                )
                presenter?.prepareError(response)
            }
        }
    }
    
    private func showLoading() {
        let response = M_ActiveSubModels.Response.Loading(title: "Загрузка", descr: "Подождите немного...")
        presenter?.prepareLoading(response)
    }
    
    private func handleNotification() {
        if self.model.findUnreadMessages() {
            if let notification = self.model.notification {
                let response = M_ActiveSubModels.Response.Debt(notification: notification)
                self.presenter?.prepareDebtNotifications(response)
            }
        }
    }
    
    deinit {
        #if DEBUG
        print("🥰🥰🥰 Active interactor deinited")
        #endif
    }
}
