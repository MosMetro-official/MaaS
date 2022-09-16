//
//  M_BuySubController.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import UIKit
import SafariServices

protocol M_BuySubscriptionDisplayLogic: AnyObject {
    func popViewController()
    func startRequestPayment()
    func displayPaymentController(_ url: URL)
    func displaySubscription(_ viewModel: M_BuySubscriptionModels.ViewModel.ViewState)
}

final class M_BuySubController: UIViewController {
    
    private let nestedView = M_BuySubView.loadFromNib()
    var interactor: M_BuySubscriptionBusinessLogic?
    var router: (M_BuySubscriptionRoutingLogic & M_BuySubscriptionDataPassing)?
    var paymentController: SFSafariViewController?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
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
                self.router?.routeToResultScreen(.success)
            }
        }
    }
    
    @objc private func handleDeclined() {
        let request = M_BuySubscriptionModels.Request.Loading(title: "Привязываем подписку...")
        interactor?.requestLoading(request)
        hidePaymentController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.router?.routeToResultScreen(.failure)
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
    
    func displaySubscription(_ viewModel: M_BuySubscriptionModels.ViewModel.ViewState) {
        nestedView.viewModel = viewModel
    }
    
    func displayPaymentController(_ url: URL) {
        paymentController = SFSafariViewController(url: url)
        if let paymentController = paymentController {
            paymentController.delegate = self
            router?.showPaymentController(paymentController)
        }
    }
    
    func startRequestPayment() {
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
