//
//  M_BuySubscriptionPresenter.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

protocol M_BuySubscriptionPresentationLogic: AnyObject {
    func prepareViewModel(_ response: M_BuySubscriptionModels.Response.Subscription)
    func preparePaymentController(_ response: M_BuySubscriptionModels.Response.PaymentPath)
    func prepareLoadingState(_ response: M_BuySubscriptionModels.Response.Loading)
    func prepareErrorState(_ response: M_BuySubscriptionModels.Response.Error)
}

final class M_BuySubscriptionPresenter: M_BuySubscriptionPresentationLogic {
    
    weak var controller: M_BuySubscriptionDisplayLogic?
    
    init(controller: M_BuySubscriptionDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareViewModel(_ response: M_BuySubscriptionModels.Response.Subscription) {
        let states = makeState(from: response)
        let linkCommand = Command { [weak self] in
            guard let self = self else { return }
            self.controller?.startRequestPayment()
        }
        let viewState = M_BuySubView.ViewState(state: states, dataState: .loaded, linkCardCommand: linkCommand)
        let viewModel = M_BuySubscriptionModels.ViewModel(viewState: viewState)
        controller?.displaySubscription(viewModel)
    }
    
    func preparePaymentController(_ response: M_BuySubscriptionModels.Response.PaymentPath) {
        guard let url = URL(string: response.path) else { return }
        controller?.displayPaymentController(url)
    }
    
    func prepareLoadingState(_ response: M_BuySubscriptionModels.Response.Loading) {
        let loading = M_BuySubView.ViewState.Loading(title: response.title, descr: response.descr)
        let viewState = M_BuySubView.ViewState(state: [], dataState: .loading(loading), linkCardCommand: nil)
        let viewModel = M_BuySubscriptionModels.ViewModel(viewState: viewState)
        controller?.displaySubscription(viewModel)
    }
    
    func prepareErrorState(_ response: M_BuySubscriptionModels.Response.Error) {
        let onClose = Command {
            self.controller?.popViewController()
        }
        let onRetry = Command {
            self.controller?.startRequestPayment()
        }
        let error = M_BuySubView.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onRetry: onRetry,
            onClose: onClose
        )
        let viewState = M_BuySubView.ViewState(state: [], dataState: .error(error), linkCardCommand: nil)
        let viewModel = M_BuySubscriptionModels.ViewModel(viewState: viewState)
        controller?.displaySubscription(viewModel)
    }
    
    private func makeState(from response: M_BuySubscriptionModels.Response.Subscription) -> [State] {
        let sortedTariffs = response.sub.tariffs.sorted(by: { $0.serviceId < $1.serviceId })
        let width: CGFloat = UIScreen.main.bounds.width - 16 - 16
        var states: [State] = []
        sortedTariffs.forEach { tariff in
            let name = tariff.name?.ru ?? "unknown"
            let descr = tariff.description?.ru ?? "unknown"
            let titleHeight = name.height(
                withConstrainedWidth: width,
                font: Appearance.getFont(.debt)
            )
            let descrHeight = descr.height(
                withConstrainedWidth: width,
                font: Appearance.getFont(.body)
            )
            let descrRow = M_BuySubView.ViewState.DescrRow(
                id: tariff.tariffId,
                title: name,
                descr: descr,
                imageUrl: tariff.imageURL,
                height: titleHeight + descrHeight + 15 + 30
            ).toElement()
            let descrState = State(model: SectionState(id: "descr", header: nil, footer: nil), elements: [descrRow])
            states.append(descrState)
        }
        let name = response.sub.name?.ru ?? "unknown"
        let titleHeaderHeight = name.height(
            withConstrainedWidth: width,
            font: Appearance.getFont(.header)
        )
        let priceHeight = "\(response.sub.price)".height(
            withConstrainedWidth: width,
            font: Appearance.getFont(.body)
        )
        let subHeader = M_BuySubView.ViewState.SubHeader(
            id: response.sub.id,
            title: name,
            price: "\(response.sub.price / 100) ₽",
            height: titleHeaderHeight + priceHeight + 30
        )
        states[0].model = SectionState(id: "subHeader", header: subHeader, footer: nil)
        return states
    }
    
}
