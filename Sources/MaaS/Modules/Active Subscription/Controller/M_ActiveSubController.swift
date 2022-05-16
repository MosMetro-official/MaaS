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
        var elements: [Element] = []
        let cardNumberHeight = userSubscritpion.cardNumber.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.customFonts[.card] ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        )
        let cardDescriptionHeight = "Для прохода в транспорте".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.customFonts[.smallBody] ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        )
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(
            cardImage: userSubscritpion.cardImage,
            cardNumber: userSubscritpion.cardNumber,
            cardDescription: "Для прохода в транспорте",
            height: cardNumberHeight + cardDescriptionHeight + 48
        ).toElement()
        let title = "МультиТранспорт"
        let titleHeight = title.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 57,
            font: Appearance.customFonts[.largeTitle] ?? UIFont.systemFont(ofSize: 30, weight: .bold)
        )
        let activeHeight = userSubscritpion.active.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 20,
            font: Appearance.customFonts[.body] ?? UIFont.systemFont(ofSize: 15, weight: .regular)
        )
        let titleHeader = M_ActiveSubView.ViewState.TitleHeader(
            title: title,
            timeLeft: userSubscritpion.active,
            height: titleHeight + activeHeight + 83
        )
        let cardState = State(model: SectionState(header: titleHeader, footer: nil), elements: [cardInfo])
        states.append(cardState)
        let tariffTitle = "Баланс"
        let tariffHeight = tariffTitle.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 16,
            font: Appearance.customFonts[.header] ?? UIFont.systemFont(ofSize: 20, weight: .bold)
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
                font: Appearance.customFonts[.body] ?? UIFont.systemFont(ofSize: 15, weight: .regular)
            )
            let typeHeight = typeTitle.height(
                withConstrainedWidth: 100,
                font: Appearance.customFonts[.body] ?? UIFont.systemFont(ofSize: 15, weight: .regular)
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
        states.append(tariffState)
        
        let onOnboardingSelect = Command {
            print("show onboarding controller")
        }
        
        let onHistorySelect = Command {
            print("show history controller")
        }
        let onboarding = M_ActiveSubView.ViewState.Onboarding(onOnboardingSelect: onOnboardingSelect, onHistorySelect: onHistorySelect).toElement()
        let onboardingState = State(model: SectionState(header: nil, footer: nil), elements: [onboarding])
        states.append(onboardingState)
        let viewState = M_ActiveSubView.ViewState(timeLeft: "Активна до 22 марта 2022", state: states, dataState: .loaded)
        nestedView.viewState = viewState
    }
}