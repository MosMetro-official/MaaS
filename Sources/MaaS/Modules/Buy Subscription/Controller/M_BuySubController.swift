//
//  M_BuySubController.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import SafariServices
import CoreAnalytics

protocol M_BuySubscriptionDisplayLogic: AnyObject {
    func popViewController()
    func startRequestPayment()
    func displayPaymentController(_ url: URL)
    func displaySubscription(_ viewModel: M_BuySubscriptionModels.ViewModel)
}

final class M_BuySubController: UIViewController {
    
    private let nestedView = M_BuySubView.loadFromNib()
    private var paymentController: SFSafariViewController?
    private var analyticsEvents = M_AnalyticsEvents()
    private var analyticsManager : _AnalyticsManager
    
    var interactor: M_BuySubscriptionBusinessLogic?
    var router: (M_BuySubscriptionRoutingLogic & M_BuySubscriptionDataPassing)?
    
    public init(analyticsManager: _AnalyticsManager) {
        self.analyticsManager = analyticsManager
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let presenter = M_BuySubscriptionPresenter(controller: self)
        let interactor = M_BuySubscriptionInteractor(presenter: presenter)
        let router = M_BuySubscriptionRouter(controller: self, dataStore: interactor)
        self.interactor = interactor
        self.router = router
    }
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        interactor?.requestState()
        setListeners()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "Подписка"
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccess), name: .maasPaymentSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeclined), name: .maasPaymentDeclined, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCanceled), name: .maasPaymentCanceled, object: nil)
    }
    
    @objc private func handleSuccess() {
        let request = M_BuySubscriptionModels.Request.Loading(title: "Привязываем подписку...")
        interactor?.requestLoading(request)
        hidePaymentController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router?.routeToResultScreen(.success, analytics: self.analyticsManager)
            }
        }
    }
    
    @objc private func handleDeclined() {
        let request = M_BuySubscriptionModels.Request.Loading(title: "Привязываем подписку...")
        interactor?.requestLoading(request)
        hidePaymentController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router?.routeToResultScreen(.failure, analytics: self.analyticsManager)
            }
        }
    }
    
    @objc private func handleCanceled() {
        interactor?.requestState()
        hidePaymentController {
            // anaLyticks?
        }
    }
    
    private func hidePaymentController(onDismiss: @escaping () -> Void) {
        guard let paymentController = paymentController else {
            return
        }
        paymentController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.paymentController = nil
            onDismiss()
        }
    }
}

extension M_BuySubController: M_BuySubscriptionDisplayLogic {
    
    func displaySubscription(_ viewModel: M_BuySubscriptionModels.ViewModel) {
        nestedView.viewState = viewModel.viewState
    }
    
    func displayPaymentController(_ url: URL) {
        paymentController = SFSafariViewController(url: url)
        if let paymentController = paymentController {
            paymentController.delegate = self
            router?.showPaymentController(paymentController)
        }
    }
    
    func startRequestPayment() {
        analyticsManager.report(analyticsEvents.makeLinkCardEvent())
        analyticsManager.report(analyticsEvents.makeOldNameLinkCardEvent())
        interactor?.requestPayment()
    }
    
    func popViewController() {
        router?.popViewController()
    }
}

extension M_BuySubController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        interactor?.requestState()
    }
}
