//
//  M_StateBuilder.swift
//  MaaS
//
//  Created by Слава Платонов on 02.08.2022.
//

import CoreTableView

protocol ActiveStateBuilder {
    var needReloadCard: Bool { get set }
    func makeSupportState(onSupport: Command<Void>) -> State
    func makeTariffState(from response: M_ActiveSubModels.Response.UserInfo) -> State
    func makeOnboardingState(_ onOnboarding: Command<Void>, _ onHistory: Command<Void>) -> State
    func makeCardState(from response: M_ActiveSubModels.Response.UserInfo, onCardSelect: Command<Void>) -> [State]
    func makeDebtNotificationState(from notifications: [M_MaasDebtNotifification], onDebt: Command<Void>) -> State
}

struct M_ActiveStateBuilder: ActiveStateBuilder {
    
    var needReloadCard: Bool = false
    
    func makeCardState(from response: M_ActiveSubModels.Response.UserInfo, onCardSelect: Command<Void>) -> [State] {
        guard let user = response.user else { return [] }
        var states = [State]()
        let title = "МультиТранспорт"
        let titleHeight = title.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 57,
            font: Appearance.getFont(.largeTitle)
        )
        guard let timeTo = user.subscription?.valid?.to else { return [] }
        let timeToString = M_DateConverter.validateStringFrom(date: timeTo, format: "dd MMMM yyyy")
        let activeHeight = timeToString.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 20,
            font: Appearance.getFont(.body)
        )
        let titleHeader = M_ActiveSubView.ViewState.TitleHeader(
            id: "titleHeader",
            title: title,
            timeLeft: "Активна до \(timeToString)",
            height: titleHeight + activeHeight + 83
        )
        let cardNumberHeight = user.payment?.card?.maskedPan.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.getFont(.card)
        ) ?? 0
        let cardDescriptionHeight = "Для прохода в транспорте".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.getFont(.smallBody)
        )
        let leftCountChageCardHeight = "Осталось смен карты – 3".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 36 - 29,
            font: Appearance.getFont(.smallBody)
        )
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(
            id: "cardInfo",
            cardImage: user.paySystem ?? .unknown,
            cardNumber: "•••• \(user.maskedPan)",
            cardDescription: "Для прохода в транспорте",
            leftCountChangeCard: "Осталось смен карты - \(user.keyChangeLeft)",
            isUpdate: needReloadCard,
            onItemSelect: onCardSelect,
            height: cardNumberHeight + cardDescriptionHeight + leftCountChageCardHeight + 48
        ).toElement()
        let cardState = State(model: SectionState(id: "cardInfo", header: titleHeader, footer: nil), elements: [cardInfo])
        states.append(cardState)
        return states
    }

    func makeTariffState(from response: M_ActiveSubModels.Response.UserInfo) -> State {
        var elements: [Element] = []
        let tariffTitle = "Баланс"
        let tariffHeight = tariffTitle.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 16,
            font: Appearance.getFont(.header)
        )
        let tariffSection = M_ActiveSubView.ViewState.HeaderCell(id: "tarfiffSection", height: tariffHeight + 24).toElement()
        elements.append(tariffSection)
        response.user?.subscription?.tariffs.forEach { tariff in
            var currentProgress: CGFloat? = nil
            // currentProgress = CGFloat(1 - (Float(tariff.trip.count) / Float(tariff.trip.total)))
            let name = tariff.name.ru
            let descr = tariff.description.ru
            let titleHeight = name.height(
                withConstrainedWidth: UIScreen.main.bounds.width - 16 - 68,
                font: Appearance.getFont(.body)
            ) + 10
            let typeHeight = descr.height(
                withConstrainedWidth: UIScreen.main.bounds.width - 16 - 68,
                font: Appearance.getFont(.body)
            ) + 10
            let progressHeight: CGFloat = currentProgress == nil ? 0 : 23
//            let tariffType = tariff.trip.count == -1 ? tariff.trip.countDescr : "Осталось \(tariff.trip.count) поездки из \(tariff.trip.total)"
            let tariffRow = M_ActiveSubView.ViewState.TariffInfo(
                id: tariff.tariffId,
                transportTitle: name,
                tariffType: descr,
                showProgress: currentProgress != nil,
                currentProgress: currentProgress,
                imageUrl: tariff.imageURL,
                height: titleHeight + typeHeight + progressHeight + 30
            ).toElement()
            elements.append(tariffRow)
        }
        let tariffState = State(model: SectionState(id: "tariffs", header: nil, footer: nil), elements: elements)
        return tariffState
    }

    func makeOnboardingState(_ onOnboarding: Command<Void>, _ onHistory: Command<Void>) -> State {
        let onboarding = M_ActiveSubView.ViewState.Onboarding(
            onOnboardingSelect: onOnboarding,
            onHistorySelect: onHistory
        ).toElement()
        let onboardingState = State(model: SectionState(id: "onboarding", header: nil, footer: nil), elements: [onboarding])
        return onboardingState
    }

    func makeDebtNotificationState(from notifications: [M_MaasDebtNotifification], onDebt: Command<Void>) -> State {
            let newNotifications = notifications.filter { $0.read == false }
            let notificationDescr: String
            if newNotifications.isEmpty {
                notificationDescr = ""
            } else if newNotifications.count == 1 {
                notificationDescr = "1 новое"
            } else {
                notificationDescr = "\(newNotifications.count) новых"
            }
            let titleHeight = "Уведомления".height(
                withConstrainedWidth: UIScreen.main.bounds.width - 40,
                font: Appearance.getFont(.card)
            )
            let debtElement = M_ActiveSubView.ViewState.DebtNotification(
                id: "debt",
                notificationDescr: notificationDescr,
                onItemSelect: onDebt,
                height: titleHeight + 39
            ).toElement()
            let debtState = State(model: SectionState(id: "debtsSection", header: nil, footer: nil), elements: [debtElement])
            return debtState
    }

    func makeSupportState(onSupport: Command<Void>) -> State {
        let titleHeight = "У меня проблема с оплатой".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 40,
            font: Appearance.getFont(.card)
        )
        let supportElement = M_ActiveSubView.ViewState.Support(
            id: "supportElement",
            onItemSelect: onSupport,
            height: titleHeight + 39
        ).toElement()
        let supportState = State(model: SectionState(id: "supportSection", header: nil, footer: nil), elements: [supportElement])
        return supportState
    }
}
