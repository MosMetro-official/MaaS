//
//  M_ActiveSubController.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit
import CoreTableView

class M_ActiveSubController: UIViewController {
    
    private let nestedView = M_ActiveSubView.loadFromNib()
    private let userSubscritpion = UserSubscription.getUserSubscription()
    private var hasDebit = true
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        makeState()
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
    }
        
    private func makeState() {
        var states: [State] = []
        let cardState = makeCardState(from: userSubscritpion)
        states.append(contentsOf: cardState)
        let tariffState = makeTariffState(from: userSubscritpion)
        states.append(tariffState)
        let onboardingState = makeOnboardingState()
        states.append(onboardingState)
        let supportState = makeSupportState()
        states.append(supportState)
        let viewState = M_ActiveSubView.ViewState(timeLeft: userSubscritpion.active, state: states, dataState: .loaded)
        nestedView.viewState = viewState
    }
}

extension M_ActiveSubController {
    private func makeDebtElement() -> Element {
        let debtInfo = "У вас есть долг"
        let debtTotal = "267,5 ₽"
        let debtInfoHeight = debtInfo.height(withConstrainedWidth: 75, font: Appearance.getFont(.smallBody))
        let debtTotalHeight = debtTotal.height(withConstrainedWidth: 75, font: Appearance.getFont(.debt))
        let onMoreButton = Command {
            print("open screen about debt")
        }
        let debtInfoCell = M_ActiveSubView.ViewState.DebtInfo(
            totalDebt: debtTotal,
            onButton: onMoreButton,
            height: debtInfoHeight + debtTotalHeight + 24
        ).toElement()
        return debtInfoCell
    }
    
    private func makeCardState(from sub: UserSubscription) -> [State] {
        var states = [State]()
        let title = "МультиТранспорт"
        let titleHeight = title.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 57,
            font: Appearance.getFont(.largeTitle)
        )
        let activeHeight = userSubscritpion.active.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 20,
            font: Appearance.getFont(.body)
        )
        let titleHeader = M_ActiveSubView.ViewState.TitleHeader(
            title: title,
            timeLeft: userSubscritpion.active,
            height: titleHeight + activeHeight + 83
        )
        if hasDebit {
            let debtElement = makeDebtElement()
            let debtState = State(model: SectionState(header: titleHeader, footer: nil), elements: [debtElement])
            states.append(debtState)
        }
        
        let cardNumberHeight = userSubscritpion.cardNumber.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.getFont(.card)
        )
        let cardDescriptionHeight = "Для прохода в транспорте".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.getFont(.smallBody)
        )
        let leftCountChageCardHeight = "Осталось смен карты – 3".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.getFont(.smallBody)
        )
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(
            cardImage: userSubscritpion.cardImage,
            cardNumber: userSubscritpion.cardNumber,
            cardDescription: "Для прохода в транспорте",
            leftCountChangeCard: "Осталось смен карты – 3",
            height: cardNumberHeight + cardDescriptionHeight + leftCountChageCardHeight + 48
        ).toElement()
        let cardState = State(model: SectionState(header: hasDebit ? nil : titleHeader, footer: nil), elements: [cardInfo])
        states.append(cardState)
        return states
    }
    
    private func makeTariffState(from sub: UserSubscription) -> State {
        var elements: [Element] = []
        let tariffTitle = "Баланс"
        let tariffHeight = tariffTitle.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 16,
            font: Appearance.getFont(.header)
        )
        let tariffSection = M_ActiveSubView.ViewState.HeaderCell(height: tariffHeight + 24).toElement()
        elements.append(tariffSection)
        userSubscritpion.tariffs.forEach { tariff in
            var currentProgress: CGFloat? = nil
            var typeTitle = tariff.type ?? ""
            if let totalCount = tariff.totalTripCount, let leftCount = tariff.leftTripCount {
                currentProgress = CGFloat(1 - (Float(leftCount) / Float(totalCount)))
                typeTitle = "Осталось \(leftCount) поездки из \(totalCount)"
            }
            let titleHeight = tariff.title.height(
                withConstrainedWidth: 100,
                font: Appearance.getFont(.body)
            )
            let typeHeight = typeTitle.height(
                withConstrainedWidth: 100,
                font: Appearance.getFont(.body)
            )
            let progressHeight: CGFloat = currentProgress == nil ? 0 : 23
            let tariffRow = M_ActiveSubView.ViewState.TariffInfo(
                transportTitle: tariff.title,
                tariffType: typeTitle,
                showProgress: currentProgress != nil,
                currentProgress: currentProgress,
                height: titleHeight + typeHeight + progressHeight + 26
            ).toElement()
            elements.append(tariffRow)
        }
        let tariffState = State(model: SectionState(header: nil, footer: nil), elements: elements)
        return tariffState
    }
    
    private func makeOnboardingState() -> State {
        let onOnboardingSelect = Command {
            print("show onboarding controller")
        }
        
        let onHistorySelect = Command {
            print("show history controller")
        }
        let onboarding = M_ActiveSubView.ViewState.Onboarding(onOnboardingSelect: onOnboardingSelect, onHistorySelect: onHistorySelect).toElement()
        let onboardingState = State(model: SectionState(header: nil, footer: nil), elements: [onboarding])
        return onboardingState
    }
    
    private func makeSupportState() -> State {
        let titleHeight = "Написать в поддержку".height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: Appearance.getFont(.card))
        let onSupport = Command {
            print("open support web view")
        }
        let supportElement = M_ActiveSubView.ViewState.Support(
            onItemSelect: onSupport,
            height: titleHeight + 39
        ).toElement()
        let supportState = State(model: SectionState(header: nil, footer: nil), elements: [supportElement])
        return supportState
    }
}
