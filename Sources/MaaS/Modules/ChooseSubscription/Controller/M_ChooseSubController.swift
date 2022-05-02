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
        setupBackButton()
        showActiveSubTest()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
        makeState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedSub = nil
    }
    
    private func setState(state: M_ChooseSubView.ViewState) {
        self.nestedView.viewState = state
    }
    
    private func makeState() {
        var subStates: [State] = []
        subscriptions.forEach { sub in
            let onItemSelect = Command {
                self.selectedSub = sub
                self.selectMakeMySub = false
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
        let onItemSelect = Command {
            self.selectMakeMySub = true
            self.selectedSub = nil
        }
        let makeMySubElement = M_ChooseSubView.ViewState.MakeMySubRow(isSelect: selectMakeMySub, onItemSelect: onItemSelect).toElement()
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
        let viewState = M_ChooseSubView.ViewState(state: subStates, dataState: .loaded, payButtonEnable: selectedSub != nil || selectMakeMySub == true, payButtonTitle: buttonTitle, payCommand: nil)
        setState(state: viewState)
    }
}
