//
//  M_ActiveSubInteractor.swift
//  MaaS
//
//  Created by Слава Платонов on 01.08.2022.
//

import CoreTableView

protocol ActiveSubscriptionInteractor: AnyObject {
    func fetchUserInfo()
    func fetchSupportUrl()
    func checkCardUpdates()
}

protocol ActiveDataStore: AnyObject {
    var userInfo: M_UserInfo? { get set }
    var notifications: [M_MaasDebtNotifification]? { get set }
    var maskedPan: String? { get set }
}

final class M_ActiveSubInteractor: ActiveSubscriptionInteractor, ActiveDataStore {
    
    var presenter: ActiveSubscriptionPresenter?
    var userInfo: M_UserInfo?
    var notifications: [M_MaasDebtNotifification]?
    var maskedPan: String? {
        didSet {
            model.oldMaskedPan = maskedPan
        }
    }
    
    private var model = M_ActiveSubModels.Response.UserInfo()
    
    init(presenter: ActiveSubscriptionPresenter? = nil) {
        self.presenter = presenter
    }
    
    func fetchUserInfo() {
        showLoading()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        M_MaasDebtNotifification.fetchDebts { result in
            switch result {
            case .success(let notifications):
                self.model.debtNotifications = notifications
                if self.model.findUnreadMessages() {
                    if let notification = self.model.notification {
                        let response = M_ActiveSubModels.Response.Debt(notification: notification)
                        self.presenter?.prepareDebtNotifications(response)
                    }
                }
                dispatchGroup.leave()
            case .failure(let error):
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.errorDescription,
                    isCardError: false
                )
                self.presenter?.prepareError(response)
                dispatchGroup.leave()
                return
            }
        }
        dispatchGroup.enter()
        M_UserInfo.fetchUserInfo { result in
            switch result {
            case .success(let userInfo):
                self.userInfo = userInfo
                self.model.user = userInfo
                self.model.newMaskedPan = userInfo.maskedPan
                dispatchGroup.leave()
            case .failure(let error):
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.errorDescription,
                    isCardError: false
                )
                self.presenter?.prepareError(response)
                dispatchGroup.leave()
                return
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("All done")
            self.presenter?.prepareResultState(self.model)
        }
    }
    
    func checkCardUpdates() {
        var count = 0
        M_UserInfo.fetchUserInfo { result in
            switch result {
            case .success(let userInfo):
                self.model.newMaskedPan = userInfo.maskedPan
                if self.model.needReloadCard, count <= 5 {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        count += 1
                        self.checkCardUpdates()
                    }
                }
                self.presenter?.prepareResultState(self.model)
            case .failure(let error):
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.errorDescription,
                    isCardError: true
                )
                self.presenter?.prepareError(response)
            }
        }
    }
    
    func fetchSupportUrl() {
        showLoading()
        M_SupportResponse.sendSupportRequest(redirectUrl: MaaS.supportForm) { result in
            switch result {
            case .success(let supportForm):
                let response = M_ActiveSubModels.Response.SupportForm(url: supportForm.url)
                self.presenter?.prepareSupportForm(response)
            case .failure(let error):
                let response = M_ActiveSubModels.Response.Error(
                    title: "Произошла ошибка 🥲",
                    descr: error.errorDescription,
                    isCardError: false
                )
                self.presenter?.prepareError(response)
            }
        }
    }
    
    private func showLoading() {
        let response = M_ActiveSubModels.Response.Loading(title: "Загрузка", descr: "Подождите немного...")
        presenter?.prepareLoading(response)
    }
    
    deinit {
        print("🥰🥰🥰 ActiveInteractor deinited")
    }
}
