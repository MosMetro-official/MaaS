//
//  M_BuySubController.swift
//  
//
//  Created by Слава Платонов on 11.05.2022.
//

import UIKit
import CoreTableView
import SafariServices

class M_BuySubController: UIViewController {
    
    private let nestedView = M_BuySubView.loadFromNib()
    
    var selectedSub: M_SubscriptionInfo? {
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
        title = "Подписка"
        setupBackButton()
    }
    
    private func makeState() {
        guard let sub = selectedSub else { return }
        let width = UIScreen.main.bounds.width - 72
        let imageHeight: CGFloat = 30
        let titleHeight = sub.name.ru.height(withConstrainedWidth: width, font: Appearance.getFont(.header)) + 55
        let stackViewHeight = imageHeight * CGFloat(sub.services.count)
        let spacingHeight: CGFloat = 8 * CGFloat(sub.services.count)
        let title = sub.name.ru.components(separatedBy: " ").dropFirst().joined(separator: " ")
        let subElement = M_BuySubView.ViewState.SubSectionRow(
            title: title,
            price: "\(sub.price / 100) ₽",
            isSelect: true,
            showSelectImage: false,
            tariffs: sub.services,
            height: titleHeight + stackViewHeight + spacingHeight
        ).toElement()
        let subState = State(model: SectionState(header: nil, footer: nil), elements: [subElement])
        let linkCommand = Command { [weak self] in
            // do some
            guard
                let url = URL(string: "https://mosmetro.ru/app/"),
                let self = self else { return }
            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true)
        }
        nestedView.viewState = .init(state: [subState], linkCardCommand: linkCommand)
    }
}
