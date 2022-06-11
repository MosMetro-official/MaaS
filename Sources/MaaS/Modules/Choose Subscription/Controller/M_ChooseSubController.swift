//
//  M_ChooseSub.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

class M_ChooseSubController: UIViewController {
    
    private let nestedView = M_ChooseSubView.loadFromNib()
    
    private var subscriptions: [M_SubscriptionInfo] = [] {
        didSet {
            makeState()
        }
    }
    
    private var selectedSub: M_SubscriptionInfo? {
        didSet {
            makeState()
        }
    }
    private var selectMakeMySub = false {
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
        loadSubscriptions()
        showActiveSubTest()
        
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedSub = nil
        selectMakeMySub = false
    }
    
    private func loadSubscriptions() {
        showLoading()
        M_SubscriptionInfo.getSubscriptions { resutl in
            switch resutl {
            case .success(let subscriptions):
                self.subscriptions = subscriptions
                print(subscriptions)
            case .failure(let error):
                print(error.localizedDescription)
                self.showError()
            }
        }
    }
    
    private func showError() {
        let onRetry = Command { [weak self] in
            self?.loadSubscriptions()
        }
        let onClose = Command { }
        let error = M_ChooseSubView.ViewState.Error(title: "Ошибка", descr: "Что-то пошло не по плану", onRetry: onRetry, onClose: onClose)
        nestedView.viewState = .init(state: [], dataState: .error(error), payButtonEnable: false, payButtonTitle: "", payCommand: nil)
    }
    
    private func showLoading() {
        let loading = M_ChooseSubView.ViewState.Loading(title: "Загрузка", descr: "Подождите еще чуть чуть :)")
        nestedView.viewState = .init(state: [], dataState: .loading(loading), payButtonEnable: false, payButtonTitle: "", payCommand: nil)
    }
    
    private func makeState() {
        var subStates: [State] = []
        subscriptions.forEach { sub in
            let onItemSelect = Command {
                self.selectedSub = sub
                self.selectMakeMySub = false
            }
            let width = UIScreen.main.bounds.width - 72
            let imageHeight: CGFloat = 30
            let titleHeight = sub.name.ru.height(withConstrainedWidth: width, font: Appearance.getFont(.header)) + 55
            let title = sub.name.ru.components(separatedBy: " ").dropFirst().joined(separator: " ")
            let stackViewHeight = imageHeight * CGFloat(sub.services.count)
            let spacingHeight: CGFloat = 8 * CGFloat(sub.services.count)
            let subElement = M_ChooseSubView.ViewState.SubSectionRow(
                title: title,
                price: "\(sub.price / 100) ₽",
                isSelect: sub == selectedSub,
                showSelectImage: true,
                tariffs: sub.services,
                onItemSelect: onItemSelect,
                height: titleHeight + stackViewHeight + spacingHeight
            ).toElement()
            let subState = State(model: SectionState(header: nil, footer: nil), elements: [subElement])
            subStates.append(subState)
        }
        let makeMySubState = createMySubState()
        subStates.append(makeMySubState)
        let buttonTitle = confirmButton()
        let payCommand = Command { [weak self] in
            guard let self = self,
                  let navigation = self.navigationController else { return }
            if self.selectMakeMySub {
                // open create sub screen
            } else {
                if let sub = self.selectedSub {
                    let buySubController = M_BuySubController()
                    buySubController.selectedSub = sub
                    navigation.pushViewController(buySubController, animated: true)
                }
            }
        }
        let viewState = M_ChooseSubView.ViewState(state: subStates, dataState: .loaded, payButtonEnable: selectedSub != nil || selectMakeMySub, payButtonTitle: buttonTitle, payCommand: payCommand)
        nestedView.viewState = viewState
    }
}

extension M_ChooseSubController {
    private func createMySubState() -> State {
        let onItemSelect = Command {
            self.selectMakeMySub = true
            self.selectedSub = nil
        }
        let title = "Собрать свой тариф"
        let descr = "Выберите столько поездок, сколько нужно именно Вам"
        let width = UIScreen.main.bounds.width - 32
        let titleHeight = title.height(withConstrainedWidth: width, font: Appearance.getFont(.header))
        let descrHeight = descr.height(withConstrainedWidth: width, font: Appearance.getFont(.smallBody))
        let makeMySubElement = M_ChooseSubView.ViewState.MakeMySubRow(
            title: title,
            descr: descr,
            isSelect: selectMakeMySub,
            onItemSelect: onItemSelect,
            height: titleHeight + descrHeight + 70
        ).toElement()
        let makeMySubState = State(model: SectionState(header: nil, footer: nil), elements: [makeMySubElement])
        return makeMySubState
    }
    
    private func confirmButton() -> String {
        var buttonTitle: String
        if var price = selectedSub?.price {
            price /= 100
            buttonTitle = "Оплатить \(price) ₽"
        } else if selectMakeMySub {
            buttonTitle = "Продолжить"
        } else {
            buttonTitle = ""
        }
        return buttonTitle
    }
}
