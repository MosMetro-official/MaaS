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

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    public func configure(with data: _SubHeader) {
        titleLabel.text = data.title
        priceLabel.text = data.price
    }
    
}
