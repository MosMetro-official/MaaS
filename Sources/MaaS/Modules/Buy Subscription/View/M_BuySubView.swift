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
        let dataState: DataState
        let linkCardCommand: Command<Void>?
        
        enum DataState {
            case loaded
            case loading(_Loading)
            case error(_Error)
        }
        
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
    
    @IBOutlet private weak var titleLabel: GradientLabel!
    @IBOutlet weak var descrLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet private weak var tableView: BaseTableView!
    @IBOutlet private weak var payButton: UIButton!
    
    private var buttonGradient: CAGradientLayer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableView.shouldUseReload = true
        titleLabel.gradientColors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
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
    
    private func hide() {
        [tableView, titleLabel, descrLabel, infoLabel, payButton].forEach { $0?.isHidden = true }
    }
    
    private func show() {
        [tableView, titleLabel, descrLabel, infoLabel, payButton].forEach { $0?.isHidden = false }
    }
    
    private func render() {
        switch viewState.dataState {
        case .loaded:
            show()
            removeError(from: self)
            removeLoading(from: self)
            tableView.viewStateInput = viewState.state
        case .loading(let loading):
            hide()
            removeError(from: self)
            showLoading(on: self, data: loading)
        case .error(let error):
            hide()
            removeLoading(from: self)
            showError(on: self, data: error)
        }
    }
}
