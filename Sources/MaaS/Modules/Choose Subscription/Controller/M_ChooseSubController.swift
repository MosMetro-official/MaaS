//
//  M_ChooseSubController.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import CoreAnalytics

protocol M_ChooseSubscriptionDisplayLogic: AnyObject {
    func dismiss()
    func pushBuySubscription(_ sub: M_Subscription?)
    func requestSubscriptions()
    func displaySelectedSubscription(_ subscription: M_Subscription)
    func displaySubscriptions(_ viewModel: M_ChooseSubscriptionModels.ViewModel)
}

public final class M_ChooseSubController: UIViewController {
    
    private let nestedView = M_ChooseSubView.loadFromNib()
    private var analyticsEvents = M_AnalyticsEvents()
    private var analyticsManager : _AnalyticsManager
    
    var interactor: M_ChooseSubscriptionBusinessLogic?
    var router: M_ChooseSubscriptionRoutingLogic?
    
    public init(analyticsManager: _AnalyticsManager) {
        self.analyticsManager = analyticsManager
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    private func setup() {
        let presenter = M_ChooseSubscriptionPresenter(controller: self)
        let interactor = M_ChooseSubscriptionInteractor(presenter: presenter)
        let router = M_ChooseSubscriptionRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchSubscriptions()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.getAssetImage(image: "mainBackButton"),
            style: .plain,
            target: self,
            action: #selector(close)
        )
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Подписка"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
    }
    
    @objc private func close() {
        router?.dismiss()
    }
    
    deinit {
        #if DEBUG
        print("🥰🥰🥰 Choose controller deinited")
        #endif
    }
}

extension M_ChooseSubController: M_ChooseSubscriptionDisplayLogic {
    
    func displaySubscriptions(_ viewModel: M_ChooseSubscriptionModels.ViewModel) {
        nestedView.viewState = viewModel.viewState
    }
    
    func displaySelectedSubscription(_ subscription: M_Subscription) {
        interactor?.handleSubscription(subscription)
    }
    
    func requestSubscriptions() {
        interactor?.fetchSubscriptions()
    }
    
    func pushBuySubscription(_ sub: M_Subscription?) {
        if let sub {
            analyticsManager.report(analyticsEvents.makeBuySubcriptionEvent(sub))
            analyticsManager.report(analyticsEvents.makeOldNameBuySubcriptionEvent(sub))
        }
        router?.routeToBuySubscription(analytics: analyticsManager)
    }
    
    func dismiss() {
        router?.dismiss()
    }
}
