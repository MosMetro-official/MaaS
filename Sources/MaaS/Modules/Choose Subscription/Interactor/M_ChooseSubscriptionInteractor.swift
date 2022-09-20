//
//  M_ChooseSubscriptionInteractor.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

protocol M_ChooseSubscriptionBusinessLogic: AnyObject {
    func fetchSubscriptions()
    func handleSubscription(_ subsription: M_Subscription)
}

protocol M_ChooseSubscriptionDataStore: AnyObject {
    var subscription: M_Subscription? { get set }
}

final class M_ChooseSubscriptionInteractor: M_ChooseSubscriptionBusinessLogic, M_ChooseSubscriptionDataStore {
    
    var presenter: M_ChooseSubscriptionPresentationLogic?
    var subscription: M_Subscription?
    private var subscriptions: [M_Subscription] = []
    
    init(presenter: M_ChooseSubscriptionPresentationLogic? = nil) {
        self.presenter = presenter
    }
    
    func fetchSubscriptions() {
        requestLoading()
        M_Subscription.fetchSubscriptions { result in
            switch result {
            case .success(let subscriptions):
                self.subscriptions = subscriptions
                let response = M_ChooseSubscriptionModels.Response.Subscription(subs: subscriptions, selectedSub: self.subscription)
                self.presenter?.prepareViewModel(response)
            case .failure(let error):
                let response = M_ChooseSubscriptionModels.Response.Error(
                    title: error.errorTitle,
                    descr: error.errorSubtitle
                )
                self.presenter?.prepareError(response)
            }
        }
    }
    
    func handleSubscription(_ subsription: M_Subscription) {
        let response = M_ChooseSubscriptionModels.Response.Subscription(subs: subscriptions, selectedSub: subsription)
        self.subscription = subsription
        presenter?.prepareViewModel(response)
    }
    
    private func requestLoading() {
        let response = M_ChooseSubscriptionModels.Response.Loading(
            title: "Загрузка...",
            descr: "Немного подождите"
        )
        presenter?.prepareLoading(response)
    }
    
    deinit {
        #if DEBUG
        print("🥰🥰🥰 Choose interactor deinited")
        #endif
    }
    
}
