//
//  M_ChooseSub.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

class M_ChooseSubController: UIViewController {
    
    let nestedView = M_ChooseSubView.loadFromNib()
    
    private var subscriptions = Subscription.getSubscriptions()
    
    private var selectedSub: Subscription? {
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
        setupBackButton()
        showActiveSubTest()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
        makeState()
    }
    
    private func setState(state: M_ChooseSubView.ViewState) {
        self.nestedView.viewState = state
    }
    
    private func makeState() {
        var subStates: [State] = []
        subscriptions.forEach { sub in
            let onItemSelect = Command {
                self.selectedSub = sub
            }
            let subElement = M_ChooseSubView.ViewState.SubSectionRow(
                title: sub.title,
                price: sub.price,
                isSelect: sub == selectedSub,
                taxiCount: sub.taxiCount,
                trasnportTariff: sub.trasnportTariff,
                bikeTariff: sub.bikeTariff,
                onItemSelect: onItemSelect
            ).toElement()
            let subState = State(model: SectionState(header: nil, footer: nil), elements: [subElement])
            subStates.append(subState)
        }
        let emptySub = Subscription(title: "", price: "", taxiCount: "", trasnportTariff: "", bikeTariff: "")
        let onItemSelect = Command {
            self.selectedSub = emptySub
        }
        let makeMySubElement = M_ChooseSubView.ViewState.MakeMySubRow(isSelect: selectedSub == emptySub, onItemSelect: onItemSelect).toElement()
        let makeMySubState = State(model: SectionState(header: nil, footer: nil), elements: [makeMySubElement])
        subStates.append(makeMySubState)
        let buttonTitle = selectedSub == emptySub ? "Продолжить" : "Оплатить \(selectedSub?.price ?? "")"
        let viewState = M_ChooseSubView.ViewState(state: subStates, dataState: .loaded, payButtonEnable: selectedSub != nil, payButtonTitle: buttonTitle, payCommand: nil)
        setState(state: viewState)
    }
}
