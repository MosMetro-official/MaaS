//
//  M_ChooseSubscriptionController.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit

protocol M_ChooseSubscriptionDisplayLogic: AnyObject {
    func dismiss()
    func pushBuySubscription()
    func requestSubscriptions()
    func displaySelectedSubscription(_ subscription: M_Subscription)
    func displaySubscriptions(_ viewModel: M_ChooseSubscriptionModels.ViewModel)
}

final class M_ChooseSubscriptionController: UIViewController {
    
    private let nestedView = M_ChooseSubView.loadFromNib()
    var interactor: M_ChooseSubscriptionBusinessLogic?
    var router: M_ChooseSubscriptionRoutingLogic?
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let presenter = M_ChooseSubscriptionPresenter(controller: self)
        let interactor = M_ChooseSubscriptionInteractor(presenter: presenter)
        let router = M_ChooseSubscriptionRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.fetchSubscriptions()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.getAssetImage(image: "mainBackButton"),
            style: .plain,
            target: self,
            action: #selector(close)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Подписка"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
    }
    
    @objc private func close() {
        router?.dismiss()
    }
}

extension M_ChooseSubscriptionController: M_ChooseSubscriptionDisplayLogic {
    
    func displaySubscriptions(_ viewModel: M_ChooseSubscriptionModels.ViewModel) {
        nestedView.viewModel = viewModel
    }
    
    func displaySelectedSubscription(_ subscription: M_Subscription) {
        interactor?.handleSubscription(subscription)
    }
    
    func requestSubscriptions() {
        interactor?.fetchSubscriptions()
    }
    
    func pushBuySubscription() {
        router?.routeToBuySubscription()
    }
    
    func dismiss() {
        router?.dismiss()
    }
}
