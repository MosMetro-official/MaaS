//
//  M_BuySubController.swift
//  
//
//  Created by Слава Платонов on 11.05.2022.
//

import UIKit
import CoreTableView
import SafariServices

class M_BuySubController: UIViewController {
    
    private let nestedView = M_BuySubView.loadFromNib()
    
    private var safariController: SFSafariViewController?
    
    var selectedSub: M_SubscriptionInfo? {
        didSet {
            makeState()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Подписка"
        setupBackButton()
        setListeners()
    }
    
    private func showLoading(with title: String) {
        let loadingState = M_BuySubView.ViewState.Loading(title: title, descr: "Немного подождите")
        nestedView.viewState = .init(state: [], dataState: .loading(loadingState), linkCardCommand: nil)
    }
    
    private func showError(with title: String, and descr: String, onRetry: Command<Void>) {
        let onClose = Command { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        let errorState = M_BuySubView.ViewState.Error(title: title, descr: descr, onRetry: onRetry, onClose: onClose)
        nestedView.viewState = .init(state: [], dataState: .error(errorState), linkCardCommand: nil)
    }
    
    private func makeState() {
        guard let sub = selectedSub, let subName = sub.name else { return }
        let sortedService = sub.services.sorted(by: { $0.serviceId < $1.serviceId })
        let width: CGFloat = UIScreen.main.bounds.width - 16 - 16
        var states: [State] = []
        sortedService.forEach { service in
            let titleHeight = service.name.ru.height(withConstrainedWidth: width, font: Appearance.getFont(.debt))
            let descrHeight = service.description.ru.height(withConstrainedWidth: width, font: Appearance.getFont(.body))
            let descr = M_BuySubView.ViewState.DescrRow(
                title: service.name.ru,
                descr: service.description.ru,
                image: getServiceImage(by: service.serviceId),
                height: titleHeight + descrHeight + 15 + 30
            ).toElement()
            let descrState = State(model: SectionState(header: nil, footer: nil), elements: [descr])
            states.append(descrState)
        }
        let titleHeaderHeight = subName.ru.height(withConstrainedWidth: width, font: Appearance.getFont(.header))
        let priceHeight = "\(sub.price)".height(withConstrainedWidth: width, font: Appearance.getFont(.body))
        let subHeader = M_BuySubView.ViewState.SubHeader(
            title: subName.ru,
            price: "\(sub.price / 100) ₽",
            height: titleHeaderHeight + priceHeight + 30
        )
        states[0].model = SectionState(header: subHeader, footer: nil)
        let linkCommand = Command { [weak self] in
            guard let self = self else { return }
            self.startPayRequest(with: sub.id)
        }
        nestedView.viewState = .init(state: states, dataState: .loaded, linkCardCommand: linkCommand)
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccess), name: .maasPaymentSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeclined), name: .maasPaymentDeclined, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCanceled), name: .maasPaymentCanceled, object: nil)
    }
    
    private func hidePaymentController(onDismiss: @escaping () -> Void) {
        guard let safariController = safariController else {
            return
        }
        safariController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.safariController = nil
            onDismiss()
        }
    }
    
    private func openSafariController(for path: String) {
        guard let url = URL(string: path) else { return }
        safariController = SFSafariViewController(url: url)
        safariController?.delegate = self
        DispatchQueue.main.async {
            self.present(self.safariController!, animated: true)
        }
    }
    
    @objc private func handleSuccess() {
        self.showLoading(with: "Привязываем подписку...")
        hidePaymentController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                guard let sub = self.selectedSub else { return }
                let resultController = M_ResultController()
                resultController.resultModel = .successSub(sub)
                self.navigationController?.pushViewController(resultController, animated: true)
            }
        }
    }
    
    @objc private func handleDeclined() {
        self.makeState()
        hidePaymentController {
            // anaLyticks?
        }
    }
    
    @objc private func handleCanceled() {
        hidePaymentController {
            self.showLoading(with: "Привязываем подписку...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let resultController = M_ResultController()
                resultController.resultModel = .failureCard
                self.navigationController?.pushViewController(resultController, animated: true)
            }
        }
    }
    
    private func handlePaymentUrl(url: String) {
        openSafariController(for: url)
    }
    
    private func handle(response: M_SubPayStartResponse) {
        M_PayStatusResponse.statusOfPayment(for: response.paymentId) { result in
            switch result {
            case .success(let payResponse):
                var count = 0
                if payResponse.payment.url == "" && count < 5 {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        count += 1
                        self.handle(response: response)
                    }
                } else {
                    self.handlePaymentUrl(url: payResponse.payment.url)
                    self.selectedSub = payResponse.subscription
                }
            case .failure(let error):
                let onRetry = Command {
                    //
                }
                self.showError(with: error.errorTitle, and: error.errorDescription, onRetry: onRetry)
            }
        }
        
    }
    
    private func startPayRequest(with id: String) {
        self.showLoading(with: "Загрузка...")
        let req = M_SubPayStartRequest(
            maaSTariffId: id,
            payment: .init(
                paymentMethod: .CARD,
                redirectUrl: .init(
                    succeed: .succeedUrl,
                    declined: .declinedUrl,
                    canceled: .canceledUrl
                ),
                paymentToken: nil,
                id: nil
            ),
            additionalData: nil
        )
        let body = req.createRequestBody()
        print("REQUSET BODY 🔥🔥🔥 \(body)")
        M_SubPayStartRequest.purchaseRequestSub(with: body) { result in
            switch result {
            case .success(let response):
                self.handle(response: response)
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.showLoading(with: "Загрузка...")
                    self?.startPayRequest(with: id)
                }
                self.showError(with: error.errorTitle, and: error.errorDescription, onRetry: onRetry)
            }
        }
    }
    
    private func getServiceImage(by serviceId: String) -> String {
        switch serviceId {
        case "YANDEX_TAXI":
            return "taxi"
        case "MOSCOW_SUBWAY":
            return "transport"
        case "VELOBIKE":
            return "transport"
        default:
            return ""
        }
    }
}

extension M_BuySubController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.makeState()
    }
}
