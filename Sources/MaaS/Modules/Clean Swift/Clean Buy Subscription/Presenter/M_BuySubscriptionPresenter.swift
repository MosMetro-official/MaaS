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
        let viewModel = M_BuySubscriptionModels.ViewModel.ViewState(state: states, dataState: .loaded, linkCardCommand: linkCommand)
        controller?.displaySubscription(viewModel)
    }
    
    func preparePaymentController(_ response: M_BuySubscriptionModels.Response.PaymentPath) {
        guard let url = URL(string: response.path) else { return }
        controller?.displayPaymentController(url)
    }
    
    func prepareLoadingState(_ response: M_BuySubscriptionModels.Response.Loading) {
        let loading = M_BuySubscriptionModels.ViewModel.ViewState.Loading(title: response.title, descr: response.descr)
        let viewModel = M_BuySubscriptionModels.ViewModel.ViewState(state: [], dataState: .loading(loading), linkCardCommand: nil)
        controller?.displaySubscription(viewModel)
    }
    
    func prepareErrorState(_ response: M_BuySubscriptionModels.Response.Error) {
        let onClose = Command {
            self.controller?.popViewController()
        }
        let onRetry = Command {
            self.controller?.startRequestPayment()
        }
        let error = M_BuySubscriptionModels.ViewModel.ViewState.Error(
            title: response.title,
            descr: response.descr,
            onRetry: onRetry,
            onClose: onClose
        )
        let viewModel = M_BuySubscriptionModels.ViewModel.ViewState(state: [], dataState: .error(error), linkCardCommand: nil)
        controller?.displaySubscription(viewModel)
    }
    
    private func makeState(from response: M_BuySubscriptionModels.Response.Subscription) -> [State] {
        let sortedTariffs = response.sub.tariffs.sorted(by: { $0.serviceId < $1.serviceId })
        let width: CGFloat = UIScreen.main.bounds.width - 16 - 16
        var states: [State] = []
        sortedTariffs.forEach { tariff in
            let titleHeight = tariff.name.ru.height(
                withConstrainedWidth: width,
                font: Appearance.getFont(.debt)
            )
            let descrHeight = tariff.description.ru.height(
                withConstrainedWidth: width,
                font: Appearance.getFont(.body)
            )
            let descr = M_BuySubView.ViewState.DescrRow(
                id: tariff.tariffId,
                title: tariff.name.ru,
                descr: tariff.description.ru,
                imageUrl: tariff.imageURL,
                height: titleHeight + descrHeight + 15 + 30
            ).toElement()
            let descrState = State(model: SectionState(id: "descr", header: nil, footer: nil), elements: [descr])
            states.append(descrState)
        }
        let titleHeaderHeight = response.sub.name.ru.height(
            withConstrainedWidth: width,
            font: Appearance.getFont(.header)
        )
        let priceHeight = "\(response.sub.price)".height(
            withConstrainedWidth: width,
            font: Appearance.getFont(.body)
        )
        let subHeader = M_BuySubView.ViewState.SubHeader(
            id: response.sub.id,
            title: response.sub.name.ru,
            price: "\(response.sub.price / 100) ₽",
            height: titleHeaderHeight + priceHeight + 30
        )
        states[0].model = SectionState(id: "subHeader", header: subHeader, footer: nil)
        return states
    }
    
}
