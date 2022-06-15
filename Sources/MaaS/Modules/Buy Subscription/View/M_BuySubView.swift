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
        
        enum DataState {
            case loaded
            case loading(_Loading)
            case error(_Error)
        }
        
        let state: [State]
        let dataState: DataState
        let linkCardCommand: Command<Void>?
        
        struct Loading: _Loading {
            let title: String
            let descr: String
        }
        
        struct Error: _Error {
            let title: String
            let descr: String
            let onRetry: Command<Void>
            let onClose: Command<Void>
        }
        
        struct SubHeader: _SubHeader {
            let title: String
            let price: String
            let height: CGFloat
        }
        
        struct DescrRow: _DescriptionCell {
            let title: String
            let descr: String
            let image: String
            let height: CGFloat
        }
        
        static let initial = ViewState(state: [], dataState: .loaded, linkCardCommand: Command(action: {}))
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
        viewState.linkCardCommand?.perform(with: ())
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
        switch viewState.dataState {
        case .loaded:
            self.removeError(from: self)
            self.removeLoading(from: self)
            self.tableView.viewStateInput = viewState.state
        case .loading(let loading):
            self.showLoading(on: self, data: loading)
        case .error(let error):
            self.showError(on: self, data: error)
        }
        self.tableView.viewStateInput = viewState.state
    }
}
