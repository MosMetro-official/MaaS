//
//  M_ActiveSubController.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit
import CoreTableView

public class M_ActiveSubController: UIViewController {
        
    private let nestedView = M_ActiveSubView.loadFromNib()
    
    private var hasDebit: (Bool, Int) = (true, 100)
    
    private var oldMaskedPan: String?
    
    public var newMaskedPan: String? {
        didSet {
            fetchUserInfo()
        }
    }
    
    private var debit: [M_DebtInfo]? {
        didSet {
            guard let debit = debit else { return }
            checkAllPossibleDebets(from: debit)
        }
    }
        
    var needReload: Bool? {
        didSet {
            guard let reload = needReload else { return }
            if reload {
                fetchUserInfo()
            }
        }
    }
    
    public var userInfo: M_UserInfo? {
        didSet {
            makeState()
        }
    }
            
    public override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.getAssetImage(image: "mainBackButton"), style: .plain, target: self, action: #selector(addTapped))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
        title = "Подписка"
    }
    
    @objc private func addTapped() {
        self.dismiss(animated: true)
    }
    
    private func fetchUserInfo() {
        showLoading()
        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        M_DebtInfo.fetchDebtInfo { result in
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
        M_UserInfo.fetchUserInfo { result in
            switch result {
            case .success(let userInfo):
                self.oldMaskedPan = userInfo.maskedPan
                if let newMask = self.newMaskedPan, let oldMask = self.oldMaskedPan {
                    if newMask != oldMask {
                        self.fetchUserInfo()
                    }
                }
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
        nestedView.viewState = .init(state: [], dataState: .loading(loadingState))
    }
    
    private func showError(with title: String, and descr: String) {
        let onRetry = Command { [weak self] in
            self?.fetchUserInfo()
        }
        let onClose = Command { [weak self] in
            self?.dismiss(animated: true)
        }
        let errorState = M_ActiveSubView.ViewState.Error(title: title, descr: descr, onRetry: onRetry, onClose: onClose)
        nestedView.viewState = .init(state: [], dataState: .error(errorState))
    }
        
    private func makeState() {
        var states: [State] = []
        guard let userInfo = userInfo else { return }
        let cardState = makeCardState(from: userInfo)
        states.append(contentsOf: cardState)
        let tariffState = makeTariffState(from: userInfo)
        states.append(tariffState)
        let onboardingState = makeOnboardingState()
        states.append(onboardingState)
        let supportState = makeSupportState()
        states.append(supportState)
        let viewState = M_ActiveSubView.ViewState(state: states, dataState: .loaded)
        nestedView.viewState = viewState
    }
}

extension M_ActiveSubController {
    private func makeDebtElement() -> Element {
        let debtInfo = "У вас есть долг"
        let debtTotal = "\(hasDebit.1) ₽"
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
    
    private func makeCardState(from user: M_UserInfo) -> [State] {
        var states = [State]()
        let title = "МультиТранспорт"
        let titleHeight = title.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 57,
            font: Appearance.getFont(.largeTitle)
        )
        let activeHeight = user.subscription?.valid?.to.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 20,
            font: Appearance.getFont(.body)
        ) ?? 0
        guard let timeTo = user.subscription?.valid?.to else { return [] }
        let validDate = Utils.getCurrentDate(from: timeTo)
        let titleHeader = M_ActiveSubView.ViewState.TitleHeader(
            title: title,
            timeLeft: "Активна до \(validDate)",
            height: titleHeight + activeHeight + 83
        )
        if hasDebit.0 {
            let debtElement = makeDebtElement()
            let debtState = State(model: SectionState(header: titleHeader, footer: nil), elements: [debtElement])
            states.append(debtState)
        }
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
        let onCardSelect = Command { [weak self] in
            guard
                let self = self,
                let navigation = self.navigationController else { return }
            let changeCardController = M_ChangeCardController()
            changeCardController.userInfo = self.userInfo
            navigation.pushViewController(changeCardController, animated: true)
        }
        guard let limit = userInfo?.keyChangeLeft, let maskedPan = userInfo?.maskedPan else { return [] }
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(
            cardImage: user.paySystem ?? .unknown,
            cardNumber: "•••• \(maskedPan)",
            cardDescription: "Для прохода в транспорте",
            leftCountChangeCard: "Осталось смен карты - \(limit)",
            onItemSelect: onCardSelect,
            height: cardNumberHeight + cardDescriptionHeight + leftCountChageCardHeight + 48
        ).toElement()
        let cardState = State(model: SectionState(header: hasDebit.0 ? nil : titleHeader, footer: nil), elements: [cardInfo])
        states.append(cardState)
        return states
    }
    
    private func makeTariffState(from sub: M_UserInfo) -> State {
        var elements: [Element] = []
        let tariffTitle = "Баланс"
        let tariffHeight = tariffTitle.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 16,
            font: Appearance.getFont(.header)
        )
        let tariffSection = M_ActiveSubView.ViewState.HeaderCell(height: tariffHeight + 24).toElement()
        elements.append(tariffSection)
        sub.subscription?.tariffs.forEach { tariff in
            var currentProgress: CGFloat? = nil
            
            // расчет количества поездок
            let titleHeight = tariff.name.ru.height(
                withConstrainedWidth: UIScreen.main.bounds.width - 16 - 68,
                font: Appearance.getFont(.body)
            ) + 10
            let typeHeight = tariff.description.ru.height(
                withConstrainedWidth: UIScreen.main.bounds.width - 16 - 68,
                font: Appearance.getFont(.body)
            ) + 10
            let progressHeight: CGFloat = currentProgress == nil ? 0 : 23
            let tariffRow = M_ActiveSubView.ViewState.TariffInfo(
                transportTitle: tariff.name.ru,
                tariffType: tariff.trip.countDescr,
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
            let historyController = M_TripsHistoryController()
            self.navigationController?.pushViewController(historyController, animated: true)
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
        hasDebit.1 = total
        hasDebit.0 = total != 0
    }
}

public struct Utils {
    public static func getCurrentDate(from string: String) -> String {
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
