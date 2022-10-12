//
//  M_SubHeader.swift
//  MaaS
//
//  Created by Слава Платонов on 14.06.2022.
//

import UIKit
import CoreTableView

protocol _SubHeader: HeaderData {
    var title: String { get }
    var price: String { get }
}

extension _SubHeader {
    func hashValues() -> [Int] {
        return [title.hashValue, price.hashValue]
    }
    
    func header(for tableView: UITableView, section: Int) -> UIView? {
        tableView.register(M_SubHeader.nib, forHeaderFooterViewReuseIdentifier: M_SubHeader.identifire)
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: M_SubHeader.identifire) as? M_SubHeader else { return nil }
        headerView.configure(with: self)
        return headerView
    }
}

class M_SubHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var multiTitleLabel: GradientLabel!
    @IBOutlet weak var payLabel: UILabel!
    @IBOutlet weak var payDescrLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        multiTitleLabel.gradientColors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        multiTitleLabel.font = Appearance.getFont(.largeTitle)
        payDescrLabel.font = Appearance.getFont(.body)
    }
    
    public func configure(with data: _SubHeader) {
        titleLabel.text = data.title
        priceLabel.text = data.price
    }
    
}
