//
//  M_BuySubView.swift
//  
//
//  Created by Слава Платонов on 11.05.2022.
//

import UIKit
import CoreTableView

class M_BuySubView: UIView {

    struct ViewState {
        
        let state: [State]
        let linkCardCommand: Command<Void>
        
        struct SubSectionRow: _SubSectionRow {
            let title: String
            let price: String
            let isSelect: Bool
            let showSelectImage: Bool
            var tariffs: [Service]
            let height: CGFloat
        }
        
        static let initial = ViewState(state: [], linkCardCommand: Command(action: {}))
    }
    
    public var viewState: ViewState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.render()
            }
        }
    }
    
    @IBOutlet weak var titleLabel: GradientLabel!
    @IBOutlet weak var tableView: BaseTableView!
    @IBOutlet weak var payButton: UIButton!
    
    private var buttonGradient: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.shouldUseReload = true
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        payButton.layer.cornerRadius = 10
        titleLabel.gradientColors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        payButton.titleLabel?.font = Appearance.getFont(.button)
        addHorizontalGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let buttonGradient = buttonGradient else { return }
        buttonGradient.frame = CGRect(x: 0, y: 0, width: payButton.bounds.width, height: payButton.bounds.height)
    }
    
    @IBAction func linkCardButtonTapped() {
        viewState.linkCardCommand.perform(with: ())
    }
    
    private func addHorizontalGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: payButton.bounds.width, height: payButton.bounds.height)
        gradientLayer.cornerRadius = 10
        gradientLayer.colors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        self.buttonGradient = gradientLayer
        self.payButton.layer.insertSublayer(self.buttonGradient!, at: 0)
    }
    
    private func render() {
        self.tableView.viewStateInput = viewState.state
    }
}
