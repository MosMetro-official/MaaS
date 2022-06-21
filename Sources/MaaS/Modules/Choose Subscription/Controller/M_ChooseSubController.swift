//
//  M_ChooseSub.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

public class M_ChooseSubController: UIViewController {
    
    public var onDismiss: (() -> Void)?
    
    private let nestedView = M_ChooseSubView.loadFromNib()
    
    private var subscriptions: [M_Subscription] = [] {
        didSet {
            makeState()
        }
    }
    
    private var selectedSub: M_Subscription? {
        didSet {
            makeState()
        }
    }
    private var selectMakeMySub = false {
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
        loadSubscriptions()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.getAssetImage(image: "mainBackButton"), style: .plain, target: self, action: #selector(addTapped))
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedSub = nil
        selectMakeMySub = false
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Подписка"
        navigationController?.navigationBar.titleTextAttributes = [
            .font: UIFont(name: "MoscowSans-medium", size: 20) ?? UIFont.systemFont(ofSize: 20)
        ]
    }
    
    @objc private func addTapped() {
        onDismiss?()
    }
    
    private func loadSubscriptions() {
        showLoading()
        M_Subscription.fetchSubscriptions { result in
            switch result {
            case .success(let subscriptions):
                self.subscriptions = subscriptions
            case .failure(let error):
                self.showError(with: error.errorTitle, and: error.errorSubtitle)
            }
        }
    }
    
    private func showError(with title: String, and descr: String) {
        let onRetry = Command { [weak self] in
            self?.loadSubscriptions()
        }
        let onClose = Command { [weak self] in
            self?.onDismiss?()
        }
        let error = M_ChooseSubView.ViewState.Error(title: title, descr: descr, onRetry: onRetry, onClose: onClose)
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
            guard let nameOfSub = sub.name else { return }
            let width = UIScreen.main.bounds.width - 72
            let imageHeight: CGFloat = 30
            let titleHeight = nameOfSub.ru.height(withConstrainedWidth: width, font: Appearance.getFont(.header)) + 40
            let title = nameOfSub.ru.components(separatedBy: " ").dropFirst().joined(separator: " ")
            let stackViewHeight = imageHeight * CGFloat(sub.tariffs.count)
            let spacingHeight: CGFloat = 8 * CGFloat(sub.tariffs.count)
            let subElement = M_ChooseSubView.ViewState.SubSectionRow(
                title: title,
                price: "\(sub.price / 100) ₽",
                isSelect: sub == selectedSub,
                showSelectImage: true,
                // чтобы такси не прыгало, а то не красиво
                tariffs: sub.tariffs.sorted(by: { $0.serviceId < $1.serviceId }),
                onItemSelect: onItemSelect,
                height: titleHeight + stackViewHeight + spacingHeight + 22
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
                self.showAlert(with: "Еще не готово 😢", and: "Данный функционал появится немного позже 🙃.")
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
