//
//  M_BuySubscriptionInteractor.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

protocol M_BuySubscriptionBusinessLogic: AnyObject {
    func requestState()
    func requestPayment()
    func requestLoading(_ request: M_BuySubscriptionModels.Request.Loading)
}

protocol M_BuySubscriptionDataStore: AnyObject {
    var subscription: M_Subscription? { get set }
}

final class M_BuySubscriptionInteractor: M_BuySubscriptionBusinessLogic, M_BuySubscriptionDataStore {
    
    var presenter: M_BuySubscriptionPresentationLogic?
    var subscription: M_Subscription?
    
    private var repeats = 0
    
    init(presenter: M_BuySubscriptionPresentationLogic? = nil) {
        self.presenter = presenter
    }
    
    func requestState() {
        guard let sub = subscription else { return }
        let response = M_BuySubscriptionModels.Response.Subscription(sub: sub)
        presenter?.prepareViewModel(response)
    }
    
    func requestPayment() {
        guard let sub = subscription else { return }
        let body = M_SubPayStartRequest(
            maaSTariffId: sub.id,
            payment: .init(
                paymentMethod: .card,
                redirectUrl: .init(
                    succeed: MaaS.succeedUrl,
                    declined: MaaS.declinedUrl,
                    canceled: MaaS.canceledUrl
                ),
                paymentToken: nil,
                id: nil
            ),
            additionalData: nil
        )
        requestLoading()
        Task {
            do {
                let response = try await M_SubPayStartRequest.sendRequestSub(with: body)
                handle(response: response)
            } catch {
                let response = M_BuySubscriptionModels.Response.Error(title: "Произошла ошибка 🥲", descr: error.localizedDescription)
                self.presenter?.prepareErrorState(response)
            }
        }
    }
    
    func requestLoading(_ request: M_BuySubscriptionModels.Request.Loading = .init(title: "Загрузка...")) {
        let response = M_BuySubscriptionModels.Response.Loading(title: request.title, descr: "Немного подождите")
        presenter?.prepareLoadingState(response)
    }
    
    private func handle(response: M_SubPayStartResponse) {
        Task {
            do {
                let payResponse = try await M_PayStatusResponse.statusOfPayment(for: response.paymentId)
                if payResponse.payment.url.isEmpty {
                    if self.repeats < 5 {
                        debugPrint("😓 COUNT - \(self.repeats)")
                        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                            self.repeats += 1
                            self.handle(response: response)
                        }
                    } else {
                        let response = M_BuySubscriptionModels.Response.Error(title: "Произошла ошибка 🥲", descr: "Попробуйте повторить позже")
                        presenter?.prepareErrorState(response)
                    }
                } else {
                    handlePaymentUrl(path: payResponse.payment.url)
                }
            } catch {
                let response = M_BuySubscriptionModels.Response.Error(title: "Произошла ошибка 🥲", descr: error.localizedDescription)
                self.presenter?.prepareErrorState(response)
            }
        }
    }
    
    private func handlePaymentUrl(path: String) {
        let response = M_BuySubscriptionModels.Response.PaymentPath(path: path)
        presenter?.preparePaymentController(response)
    }
}
