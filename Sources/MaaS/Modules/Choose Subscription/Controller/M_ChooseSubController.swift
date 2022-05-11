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
    private var subscriptions = Subscription.getSubscriptions()
    
    private var selectedSub: Subscription? {
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
        showActiveSubTest()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.showError()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedSub = nil
        selectMakeMySub = false
    }
    
    private func showError() {
        let onRetry = Command { [weak self] in
            self?.makeState()
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
            let titleHeight = sub.title.height(withConstrainedWidth: width, font: Appearance.customFonts[.header] ?? UIFont()) + 48
            let stackViewHeight = sub.tariffs[0].transportImage.size.height * CGFloat(sub.tariffs.count)
            let spacingHeight: CGFloat = 8 * CGFloat(sub.tariffs.count)
            let subElement = M_ChooseSubView.ViewState.SubSectionRow(
                title: sub.title,
                price: sub.price,
                isSelect: sub == selectedSub,
                showSelectImage: true,
                tariffs: sub.tariffs,
                onItemSelect: onItemSelect,
                height: titleHeight + stackViewHeight + spacingHeight
            ).toElement()
            let subState = State(model: SectionState(header: nil, footer: nil), elements: [subElement])
            subStates.append(subState)
        }
        let onItemSelect = Command {
            self.selectMakeMySub = true
            self.selectedSub = nil
        }
        let title = "Собрать свой тариф"
        let descr = "Выберите столько поездок, сколько нужно именно Вам"
        let width = UIScreen.main.bounds.width - 32
        let titleHeight = title.height(withConstrainedWidth: width, font: Appearance.customFonts[.header] ?? UIFont.systemFont(ofSize: 20, weight: .bold))
        let descrHeight = descr.height(withConstrainedWidth: width, font: Appearance.customFonts[.smallBody] ?? UIFont.systemFont(ofSize: 13, weight: .regular))
        let makeMySubElement = M_ChooseSubView.ViewState.MakeMySubRow(
            title: title,
            descr: descr,
            isSelect: selectMakeMySub,
            onItemSelect: onItemSelect,
            height: titleHeight + descrHeight + 70
        ).toElement()
        let makeMySubState = State(model: SectionState(header: nil, footer: nil), elements: [makeMySubElement])
        subStates.append(makeMySubState)
        var buttonTitle: String
        if let price = selectedSub?.price {
            buttonTitle = "Оплатить \(price)"
        } else if selectMakeMySub {
            buttonTitle = "Продолжить"
        } else {
            buttonTitle = ""
        }
        let payCommand = Command { [weak self] in
            guard
                let sub = self?.selectedSub,
                let navigation = self?.navigationController else { return }
            let buySubController = M_BuySubController()
            buySubController.selectedSub = sub
            navigation.pushViewController(buySubController, animated: true)
        }
        let viewState = M_ChooseSubView.ViewState(state: subStates, dataState: .loaded, payButtonEnable: selectedSub != nil || selectMakeMySub, payButtonTitle: buttonTitle, payCommand: payCommand)
        nestedView.viewState = viewState
    }
}
