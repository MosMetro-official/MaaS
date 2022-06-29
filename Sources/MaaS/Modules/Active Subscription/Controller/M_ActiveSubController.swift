//
//  M_ActiveSubController.swift
//  
//
//  Created by Слава Платонов on 30.04.2022.
//

import UIKit
import CoreTableView
import SafariServices


public class M_ActiveSubController: UIViewController {
    
    private var model = M_ActiveSubModel() {
        didSet {
            guard let _ = model.userInfo else { return }
            makeState()
        }
    }
    
    public var oldMaskedPan: String? {
        didSet {
            model.oldMaskedPan = oldMaskedPan
        }
    }
            
    private let nestedView = M_ActiveSubView.loadFromNib()
    private var safariController: SFSafariViewController?
        
    public var needReload: Bool? {
        didSet {
            guard let reload = needReload else { return }
            if reload {
                fetchUserInfo()
            }
        }
    }
            
    public override func loadView() {
        super.loadView()
        self.view = nestedView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        showLoading()
        fetchUserInfo()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.getAssetImage(image: "mainBackButton"),
            style: .plain, target: self,
            action: #selector(closeTapped)
        )
        setListeners()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [
            .font: Appearance.getFont(.navTitle)
        ]
        title = "Подписка"
    }
    
    @objc private func closeTapped() {
        self.dismiss(animated: true)
    }
    
    private func setListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSupportForm), name: .maasSupportForm, object: nil)
    }
    
// MARK: Requests
    
    private func checkCardUpdate() {
        M_UserInfo.fetchUserInfo { result in
            switch result {
            case .success(let userInfo):
                self.model.newMaskedPan = userInfo.maskedPan
                if self.model.needReloadCard {
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        self.checkCardUpdate()
                        return
                    }
                }
                self.model.userInfo = userInfo
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.fetchUserInfo()
                }
                self.showError(with: error.errorTitle, and: error.errorDescription, onRetry: onRetry)
            }
        }
    }
        
    private func fetchUserInfo() {
        self.hideNavBar()
        self.showLoading()
        var user: M_UserInfo?
        let dispatchGroup = DispatchGroup()
//        dispatchGroup.enter()
//        M_DebtInfo.fetchDebtInfo { result in
//            switch result {
//            case .success(let debit):
//                model?.debits = debit
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
//                self.newMaskedPan = userInfo.maskedPan
                switch userInfo.subscription?.status {
                case .active:
//                    self.model.userInfo = userInfo
                    user = userInfo
                case .expired:
                    let onAction = Command { [weak self] in
                        let choose = M_ChooseSubController()
                        self?.navigationController?.pushViewController(choose, animated: true)
                    }
                    self.makeStatusInfoState(with: "Подписка закончилась", descr: "Оформите пожалуйста новую", imageStr: "checkmark", onAction: onAction, actionTitle: "Выбрать новую")
                case .blocked:
                    self.makeStatusInfoState(with: "Ваша подписка была заблокирована", descr: "Свяжитесь с нами", imageStr: "checkmark", onAction: nil)
                case .processing, .created:
                    self.makeStatusInfoState(with: "Мы обрабатываем вашу оплату", descr: "Попробуйте позже", imageStr: "checkmark", onAction: nil)
                case .unknow:
                    let onAction = Command { [weak self] in
                        self?.dismiss(animated: true)
                    }
                    self.makeStatusInfoState(with: "Мы оформляем вашу подписку", descr: "Попробуйте позже", imageStr: "checkmark", onAction: onAction, actionTitle: "Закрыть")
                case .canceled:
                    self.makeStatusInfoState(with: "Что-то пошло не так", descr: "Свяжитесь с нами", imageStr: "checkmark", onAction: nil)
                default:
                    break
                }
                self.model.newMaskedPan = userInfo.maskedPan
                dispatchGroup.leave()
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.fetchUserInfo()
                }
                self.showError(with: error.errorTitle, and: error.errorDescription, onRetry: onRetry)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            print("All done")
            self.model.userInfo = user
        }
    }
        
    private func makeState() {
        self.showNavBar()
        var states: [State] = []
        guard let userInfo = model.userInfo else { return }
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
    
    private func makeStatusInfoState(with title: String, descr: String, imageStr: String, onAction: Command<Void>?, actionTitle: String = "") {
        let image = UIImage.getAssetImage(image: imageStr)
        let statusInfo = M_ActiveSubView.ViewState.StatusInfo(
            title: title,
            descr: descr,
            imageStatus: image,
            onAction: onAction,
            actionTitle: actionTitle,
            height: UIScreen.main.bounds.height / 2
        ).toElement()
        let state = State(model: SectionState(header: nil, footer: nil), elements: [statusInfo])
        nestedView.viewState = .init(state: [state], dataState: .loaded)
    }
}

// MARK: Make state elements

extension M_ActiveSubController {
    private func makeDebtElement() -> Element? {
        let debtInfo = "У вас есть долг"
        let debtTotal = "\(model.debetInfo.totalDebet) ₽"
        let debtInfoHeight = debtInfo.height(
            withConstrainedWidth: 75,
            font: Appearance.getFont(.smallBody)
        )
        let debtTotalHeight = debtTotal.height(
            withConstrainedWidth: 75,
            font: Appearance.getFont(.debt)
        )
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
        guard let timeTo = user.subscription?.valid?.to else { return [] }
        let timeToString = M_DateConverter.validateStringFrom(date: timeTo)
        let activeHeight = timeToString.height(
            withConstrainedWidth: UIScreen.main.bounds.width - 20,
            font: Appearance.getFont(.body)
        )
        let titleHeader = M_ActiveSubView.ViewState.TitleHeader(
            title: title,
            timeLeft: "Активна до \(timeToString)",
            height: titleHeight + activeHeight + 83
        )
        if let _ = model.debits {
            guard let debtElement = makeDebtElement() else { return [] }
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
            changeCardController.userInfo = self.model.userInfo
            navigation.pushViewController(changeCardController, animated: true)
        }
        guard let limit = model.userInfo?.keyChangeLeft, let maskedPan = model.userInfo?.maskedPan else { return [] }
        let cardInfo = M_ActiveSubView.ViewState.CardInfo(
            cardImage: user.paySystem ?? .unknown,
            cardNumber: "•••• \(maskedPan)",
            cardDescription: "Для прохода в транспорте",
            leftCountChangeCard: "Осталось смен карты - \(limit)",
            isUpdate: model.needReloadCard,
            onItemSelect: onCardSelect,
            height: cardNumberHeight + cardDescriptionHeight + leftCountChageCardHeight + 48
        ).toElement()
        let cardState = State(model: SectionState(header: model.debetInfo.hasDebet ? nil : titleHeader, footer: nil), elements: [cardInfo])
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
        let onboarding = M_ActiveSubView.ViewState.Onboarding(
            onOnboardingSelect: onOnboardingSelect,
            onHistorySelect: onHistorySelect
        ).toElement()
        let onboardingState = State(model: SectionState(header: nil, footer: nil), elements: [onboarding])
        return onboardingState
    }
    
    private func makeSupportState() -> State {
        let titleHeight = "Написать в поддержку".height(
            withConstrainedWidth: UIScreen.main.bounds.width - 40,
            font: Appearance.getFont(.card)
        )
        let onSupport = Command { [weak self] in
            self?.fetchSupportUrl()
        }
        let supportElement = M_ActiveSubView.ViewState.Support(
            onItemSelect: onSupport,
            height: titleHeight + 39
        ).toElement()
        let supportState = State(model: SectionState(header: nil, footer: nil), elements: [supportElement])
        return supportState
    }
}

// MARK: Support form

extension M_ActiveSubController: SFSafariViewControllerDelegate {
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.makeState()
    }
    
    private func fetchSupportUrl() {
        self.showLoading()
        M_SupportResponse.sendSupportRequest(redirectUrl: MaaS.supportForm) { result in
            switch result {
            case .success(let supportForm):
                self.handleSupportUrl(path: supportForm.url)
            case .failure(let error):
                let onRetry = Command { [weak self] in
                    self?.fetchSupportUrl()
                }
                self.showError(with: error.errorTitle, and: error.errorDescription, onRetry: onRetry)
            }
        }
    }
    
    private func handleSupportUrl(path: String) {
        guard let url = URL(string: path) else { return }
        safariController = SFSafariViewController(url: url)
        safariController?.delegate = self
        DispatchQueue.main.async {
            self.present(self.safariController!, animated: true)
        }
    }
    
    private func hideSafatiController(onDismiss: @escaping () -> Void) {
        guard let safariController = safariController else {
            return
        }
        safariController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.safariController = nil
            onDismiss()
        }
    }
    
    @objc private func handleSupportForm() {
        hideSafatiController {
            DispatchQueue.main.async {
                self.makeState()
            }
        }
    }
}

// MARK: Errors, loading

extension M_ActiveSubController {
    
    private func showLoading() {
        let loadingState = M_ActiveSubView.ViewState.Loading(
            title: "Загрузка...",
            descr: "Подождите немного"
        )
        nestedView.viewState = .init(state: [], dataState: .loading(loadingState))
    }
    
    private func showError(with title: String, and descr: String, onRetry: Command<Void>) {
        let onClose = Command { [weak self] in
            self?.dismiss(animated: true)
        }
        let errorState = M_ActiveSubView.ViewState.Error(
            title: title,
            descr: descr,
            onRetry: onRetry,
            onClose: onClose
        )
        nestedView.viewState = .init(state: [], dataState: .error(errorState))
    }
}
