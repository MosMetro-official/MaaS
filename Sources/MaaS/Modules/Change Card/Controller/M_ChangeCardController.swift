//
//  M_ChangeCardController.swift
//  MaaS
//
//  Created by Слава Платонов on 13.06.2022.
//

import UIKit
import CoreTableView
import SafariServices

class M_ChangeCardController: UIViewController {
        
    public var userInfo: M_UserInfo?
    private var keyResponse: M_UserCardResponse?
    private var safariController: SFSafariViewController?
    
    private let nestedView = M_ChangeCardView.loadFromNib()
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeState()
        setupNavigationTitle()
        setupBackButton()
        setListeners()
    }
    
    private func setupNavigationTitle() {
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "Карта"
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSuccessChange), name: .maasChangeCardSucceed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeclinedChange), name: .maasChangeCardDeclined, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCanceledChange), name: .maasChangeCardCanceled, object: nil)
    }
    
    @objc private func handleSuccessChange() {
        self.showLoading(with: "Меняем номер вашей карты...")
        hidePaymentController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let resultController = M_ResultController()
                guard let userInfo = self.userInfo else { return }
                resultController.resultModel = .successCard(userInfo)
                self.navigationController?.pushViewController(resultController, animated: true)
            }
        }
    }
    
    @objc private func handleDeclinedChange() {
        self.makeState()
        hidePaymentController {
            // anaLiticks?
        }
    }
    
    @objc private func handleCanceledChange() {
        self.showLoading(with: "Меняем номер вашей карты...")
        hidePaymentController {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let resultController = M_ResultController()
                resultController.resultModel = .failureCard
                self.navigationController?.pushViewController(resultController, animated: true)
            }
        }
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
    
    private func sendRequestKey() {
        showLoading(with: "Загрузка...")
        let request = M_UserCardRequest(
            payData: M_PayData(
                redirectUrl: M_RedirectUrl(
                    succeed: MaaS.succeedUrlCard,
                    declined: MaaS.declinedUrlCard,
                    canceled: MaaS.canceledUrlCard
                ),
                paymentMethod: .card
            )
        )
        let body = request.createRequestBody()
        M_UserCardResponse.sendRequsetToChangeUserCard(body: body) { result in
            switch result {
            case .success(let userResponse):
                self.keyResponse = userResponse
                if let path = userResponse.payment?.url {
                    self.openSafariController(for: path)
                } else {
                    self.showError(with: "Ошибка", and: "Не удалось открыть страницу смены карты")
                }
            case .failure(let error):
                self.showError(with: error.errorTitle, and: error.errorDescription)
            }
        }
    }
    
    private func showLoading(with title: String) {
        let loadingState = M_ChangeCardView.ViewState.Loading(
            title: title,
            descr: "Осталось совсем немного"
        )
        nestedView.viewState = .init(
            dataState: .loading(loadingState),
            cardType: .unknown,
            cardNumber: "",
            countOfChangeCard: 0,
            onChangeButton: nil
        )
    }
    
    private func showError(with title: String, and descr: String) {
        let onRetry = Command { [weak self] in
            self?.sendRequestKey()
        }
        let onClose = Command { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        let errorState = M_ChangeCardView.ViewState.Error(
            title: title,
            descr: descr,
            onRetry: onRetry,
            onClose: onClose
        )
        nestedView.viewState = .init(
            dataState: .error(errorState),
            cardType: .unknown,
            cardNumber: "",
            countOfChangeCard: 0,
            onChangeButton: nil
        )
    }
    
    private func makeState() {
        guard let userInfo = userInfo else { return }
        let onChangeButton = Command { [weak self] in
            guard let self = self else { return }
            self.sendRequestKey()
        }
        let finalState = M_ChangeCardView.ViewState(
            dataState: .loaded,
            cardType: userInfo.paySystem ?? .unknown,
            cardNumber: "\(userInfo.maskedPan)",
            countOfChangeCard: userInfo.keyChangeLeft,
            onChangeButton: userInfo.keyChangeLeft == 0 ? nil : onChangeButton
        )
        self.nestedView.viewState = finalState
    }
}

extension M_ChangeCardController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        makeState()
    }
}
