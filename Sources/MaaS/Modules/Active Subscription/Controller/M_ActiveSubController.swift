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
    
    private var debit: [M_DebtInfo]? {
        didSet {
            guard let debit = debit else { return }
            checkAllPossibleDebets(from: debit)
        }
    }
    
    private var userInfo: M_UserInfoResponse? {
        didSet {
            makeState()
        }
    }
    
    var currentSub: M_CurrentSubInfo?
    
    override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
        setupBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
    }
    
    private func fetchUserInfo() {
        showLoading()
        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        M_DebtInfo.getDebtInfo { result in
//            switch result {
//            case .success(let debit):
//                self.debit = debit
//                dispatchGroup.leave()
//            case .failure(let error):
//                self.showError(with: error.errorTitle, and: error.errorDescription)
//                dispatchGroup.leave()
//            }
//        }
        dispatchGroup.enter()
        M_UserInfoResponse.fetchShortUserInfo { result in
            switch result {
            case .success(let userInfo):
                self.userInfo = userInfo
                dispatchGroup.leave()
            case .failure(let error):
                self.showError(with: error.errorTitle, and: error.errorDescription)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("All done")
        }
    }
    
    private func showLoading() {
        let loadingState = M_ActiveSubView.ViewState.Loading(title: "Загрузка...", descr: "Подождите немного")
        nestedView.viewState = .init(timeLeft: "", state: [], dataState: .loading(loadingState))
    }
    
    private func showError(with title: String, and descr: String) {
        let onRetry = Command {
            
        }
        let onClose = Command {
            
        }
        let errorState = M_ActiveSubView.ViewState.Error(title: title, descr: descr, onRetry: onRetry, onClose: onClose)
        nestedView.viewState = .init(timeLeft: "", state: [], dataState: .error(errorState))
    }
        
    private func makeState() {
        var states: [State] = []
        guard let currentSub = currentSub else { return }
        let cardState = makeCardState(from: currentSub)
        states.append(contentsOf: cardState)
        let tariffState = makeTariffState(from: currentSub)
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
    
    private func makeCardState(from sub: M_CurrentSubInfo) -> [State] {
        var states = [State]()
        let title = "МультиТранспорт"
        let titleHeight = title.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 57,
            font: Appearance.getFont(.largeTitle)
        )
        let activeHeight = sub.subscription.valid?.to.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 20,
            font: Appearance.getFont(.body)
        ) ?? 0
        guard let timeTo = sub.subscription.valid?.to else { return [] }
        let validDate = getCurrentDate(from: timeTo)
        let titleHeader = M_ActiveSubView.ViewState.TitleHeader(
            title: title,
            timeLeft: "Активна до \(validDate)",
            height: titleHeight + activeHeight + 83
        )
        if hasDebit {
            let debtElement = makeDebtElement()
            let debtState = State(model: SectionState(header: titleHeader, footer: nil), elements: [debtElement])
            states.append(debtState)
        }
        let cardNumberHeight = sub.payment?.card?.maskedPan.height(
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
        let onCardSelect = Command { [weak self] in
            guard
                let self = self,
                let navigation = self.navigationController else { return }
            let changeCardController = M_ChangeCardController()
            changeCardController.tranId = sub.payment?.card?.cardId
            navigation.pushViewController(changeCardController, animated: true)
        }
        guard let limit = userInfo?.keyChangeLimit else { return [] }
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(
            cardImage: sub.payment?.card?.paySystem?.rawValue.lowercased() ?? "visa",
            cardNumber: "••••" + " " + (currentSub?.payment?.card?.maskedPan ?? ""),
            cardDescription: "Для прохода в транспорте",
            leftCountChangeCard: "Осталось смен карты - \(limit)",
            onItemSelect: onCardSelect,
            height: cardNumberHeight + cardDescriptionHeight + leftCountChageCardHeight + 48
        ).toElement()
        let cardState = State(model: SectionState(header: hasDebit ? nil : titleHeader, footer: nil), elements: [cardInfo])
        states.append(cardState)
        return states
    }
    
    private func makeTariffState(from sub: M_CurrentSubInfo) -> State {
        var elements: [Element] = []
        let tariffTitle = "Баланс"
        let tariffHeight = tariffTitle.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 16,
            font: Appearance.getFont(.header)
        )
        let tariffSection = M_ActiveSubView.ViewState.HeaderCell(height: tariffHeight + 24).toElement()
        elements.append(tariffSection)
        sub.subscription.services.forEach { service in
            var currentProgress: CGFloat? = nil
            // расчет количества поездок
            let titleHeight = service.name.ru.height(
                withConstrainedWidth: UIScreen.main.bounds.width - 16 - 68,
                font: Appearance.getFont(.body)
            ) + 10
            let typeHeight = service.description.ru.height(
                withConstrainedWidth: UIScreen.main.bounds.width - 16 - 68,
                font: Appearance.getFont(.body)
            ) + 10
            let progressHeight: CGFloat = currentProgress == nil ? 0 : 23
            let tariffRow = M_ActiveSubView.ViewState.TariffInfo(
                transportTitle: service.name.ru,
                tariffType: service.description.ru,
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
    
    private func checkAllPossibleDebets(from debits: [M_DebtInfo]) {
        let total = debits.reduce(0) { $0 + $1.amount }
        hasDebit = total != 0
    }
    
    private func getCurrentDate(from string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = .current
            return dateFormatter.string(from: date)
        }
        return "неизвестно"
    }
}
