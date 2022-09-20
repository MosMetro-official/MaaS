//
//  M_ChooseSubscriptionPresenter.swift
//  Pods
//
//  Created by Слава Платонов on 30.08.2022.
//

import CoreTableView

protocol M_ChooseSubscriptionPresentationLogic: AnyObject {
    func prepareError(_ response: M_ChooseSubscriptionModels.Response.Error)
    func prepareLoading(_ response: M_ChooseSubscriptionModels.Response.Loading)
    func prepareViewModel(_ response: M_ChooseSubscriptionModels.Response.Subscription)
}

final class M_ChooseSubscriptionPresenter: M_ChooseSubscriptionPresentationLogic {
    
    weak var controller: M_ChooseSubscriptionDisplayLogic?
    
    init(controller: M_ChooseSubscriptionDisplayLogic? = nil) {
        self.controller = controller
    }
    
    func prepareLoading(_ response: M_ChooseSubscriptionModels.Response.Loading) {
        let loading = M_ChooseSubView.ViewState.Loading(
            title: response.title,
            descr: response.descr
        )
        let viewState = M_ChooseSubView.ViewState(
            state: [],
            dataState: .loading(loading),
            payButtonEnable: false,
            payButtonTitle: "",
            payCommand: nil
        )
        let viewModel = M_ChooseSubscriptionModels.ViewModel(viewState: viewState)
        controller?.displaySubscriptions(viewModel)
    }
    
    func prepareError(_ response: M_ChooseSubscriptionModels.Response.Error) {
        let onClose = Command {
            self.controller?.dismiss()
        }
        let onRetry = Command {
            self.controller?.requestSubscriptions()
        }
        let error = M_ChooseSubView.ViewState.Error(title: response.title, descr: response.descr, onRetry: onRetry, onClose: onClose)
        let viewState = M_ChooseSubView.ViewState(state: [], dataState: .error(error), payButtonEnable: false, payButtonTitle: "", payCommand: nil)
        let viewModel = M_ChooseSubscriptionModels.ViewModel(viewState: viewState)
        controller?.displaySubscriptions(viewModel)
    }
    
    func prepareViewModel(_ response: M_ChooseSubscriptionModels.Response.Subscription) {
        let state = makeState(from: response)
        let buttonTitle = confirmButton(for: response.selectedSub)
        let payCommand = Command {
            self.controller?.pushBuySubscription(response.selectedSub)
        }
        let viewState = M_ChooseSubView.ViewState(state: state, dataState: .loaded, payButtonEnable: response.selectedSub != nil, payButtonTitle: buttonTitle, payCommand: payCommand)
        let viewModel = M_ChooseSubscriptionModels.ViewModel(viewState: viewState)
        controller?.displaySubscriptions(viewModel)
    }
    
    private func makeState(from response: M_ChooseSubscriptionModels.Response.Subscription) -> [State] {
        var subStates: [State] = []
        response.subs.forEach { sub in
            let onItemSelect = Command {
                self.controller?.displaySelectedSubscription(sub)
            }
            let witdh = UIScreen.main.bounds.width - 72
            let imageHeight: CGFloat = 30
            let titleHeight = sub.name.ru.height(withConstrainedWidth: witdh, font: Appearance.getFont(.header)) + 40
            let title = sub.name.ru.components(separatedBy: " ").dropFirst().joined(separator: " ")
            let stackViewHeight = imageHeight * CGFloat(sub.tariffs.count)
            let spacingHeight: CGFloat = 8 * CGFloat(sub.tariffs.count)
            let price = sub.price / 100
            let tariffs = sub.tariffs.sorted { $0.serviceId < $1.serviceId }
            let subElement = M_ChooseSubView.ViewState.SubSectionRow(
                id: sub.id,
                title: title,
                price: "\(price) ₽",
                isSelect: sub == response.selectedSub,
                showSelectImage: true,
                tariffs: tariffs,
                onItemSelect: onItemSelect,
                height: titleHeight + stackViewHeight + spacingHeight + 22
            ).toElement()
            let subState = State(model: .init(id: "subs"), elements: [subElement])
            subStates.append(subState)
        }
        return subStates
    }
    
    private func confirmButton(for selectedSub: M_Subscription?) -> String {
        var buttonTitle: String
        if var price = selectedSub?.price {
            price /= 100
            buttonTitle = "Оплатить \(price) ₽"
        } else {
            buttonTitle = ""
        }
        return buttonTitle
    }
    
    deinit {
        #if DEBUG
        print("🥰🥰🥰 Choose presenter deinited")
        #endif
    }
}
