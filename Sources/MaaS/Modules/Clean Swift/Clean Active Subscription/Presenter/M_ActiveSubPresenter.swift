//
//  M_ActiveSubPresenter.swift
//  MaaS
//
//  Created by Слава Платонов on 01.08.2022.
//

import CoreTableView

protocol ActiveSubscriptionPresenter: AnyObject {
    func prepareResultState(_ response: M_ActiveSubModels.Response.UserInfo)
    func prepareError(_ response: M_ActiveSubModels.Response.Error)
    func prepareLoading(_ response: M_ActiveSubModels.Response.Loading)
    func prepareSupportForm(_ response: M_ActiveSubModels.Response.SupportForm)
    func prepareDebtNotifications(_ response: M_ActiveSubModels.Response.Debt)
}

final class M_ActiveSubPresenter: ActiveSubscriptionPresenter {
    
    weak var controller: ActiveDisplayLogic?
    private var builder: ActiveStateBuilder = M_ActiveStateBuilder()
        
    init(controller: ActiveDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareResultState(_ response: M_ActiveSubModels.Response.UserInfo) {
        var states: [State] = []
        let onCardSelect = Command {
            self.controller?.pushChangeCardScreen()
        }
        let cardState = builder.makeCardState(from: response, onCardSelect: onCardSelect)
        states.append(contentsOf: cardState)
        let tariffState = builder.makeTariffState(from: response)
        states.append(tariffState)
        let onOnboardingSelect = Command {
            self.controller?.openOnboarding()
        }
        let onHistorySelect = Command {
            self.controller?.pushHistoryScreen()
        }
        let onboardingState = builder.makeOnboardingState(onOnboardingSelect, onHistorySelect)
        states.append(onboardingState)
        if let notifications = response.debtNotifications, !notifications.isEmpty {
            let onDebt = Command {
                self.controller?.pushDebtScreen()
            }
            let debtNotificationsState = builder.makeDebtNotificationState(from: notifications, onDebt: onDebt)
            states.append(debtNotificationsState)
        }
        let onSupport = Command {
            self.controller?.requestSupportUrl()
        }
        let supportState = builder.makeSupportState(onSupport: onSupport)
        states.append(supportState)
        builder.needReloadCard = response.needReloadCard
        let viewModel = M_ActiveSubModels.ViewModel.ViewState.DataState.loaded(states)
        prepareOnboarding()
        controller?.displayUserInfo(with: viewModel)
    }
    
    func prepareSupportForm(_ response: M_ActiveSubModels.Response.SupportForm) {
        guard let url = URL(string: response.url) else { return }
        controller?.openSafariController(url)
    }
    
    func prepareDebtNotifications(_ response: M_ActiveSubModels.Response.Debt) {
        controller?.showDebtNotification(response.notification)
    }
    
    func prepareLoading(_ response: M_ActiveSubModels.Response.Loading) {
        let loading = M_ActiveSubModels.ViewModel.ViewState.Loading(title: response.title, descr: response.descr)
        let viewModel: M_ActiveSubModels.ViewModel.ViewState.DataState = .loading(loading)
        controller?.displayUserInfo(with: viewModel)
    }
    
    func prepareError(_ response: M_ActiveSubModels.Response.Error) {
        let onClose = Command {
            self.controller?.dismiss()
        }
        let onRetry = Command {
            response.isCardError ?
            self.controller?.requestCardUpdate() :
            self.controller?.requestUserInfo()
        }
        let error = M_ActiveSubModels.ViewModel.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onRetry: onRetry,
            onClose: onClose
        )
        let viewModel: M_ActiveSubModels.ViewModel.ViewState.DataState = .error(error)
        controller?.displayUserInfo(with: viewModel)
    }
    
    private func prepareOnboarding() {
        if !M_UserInfo.hasSeenOnboarding {
            controller?.openOnboarding()
        }
    }
    
    deinit {
        print("🥰🥰🥰 ActivePresenter deinited")
    }
}
