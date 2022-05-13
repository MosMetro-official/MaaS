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
    
    var selectedSub: Subscription? {
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
        let titleHeight = sub.title.height(withConstrainedWidth: width, font: Appearance.customFonts[.header] ?? UIFont()) + 48
        let stackViewHeight = sub.tariffs[0].transportImage.size.height * CGFloat(sub.tariffs.count)
        let spacingHeight: CGFloat = 8 * CGFloat(sub.tariffs.count)
        let subElement = M_BuySubView.ViewState.SubSectionRow(
            title: sub.title,
            price: sub.price,
            isSelect: true,
            showSelectImage: false,
            tariffs: sub.tariffs,
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
