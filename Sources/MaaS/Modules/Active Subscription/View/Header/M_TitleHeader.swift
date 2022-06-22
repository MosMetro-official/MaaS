//
//  M_TitleHeader.swift
//  
//
//  Created by Слава Платонов on 05.05.2022.
//

import UIKit
import CoreTableView

protocol _TitleHeader: HeaderData {
    var title: String { get }
    var timeLeft: String { get }
}

extension _TitleHeader {
    func hashValues() -> [Int] {
        return [title.hashValue, timeLeft.hashValue]
    }
    
    func header(for tableView: UITableView, section: Int) -> UIView? {
        tableView.register(M_TitleHeader.nib, forHeaderFooterViewReuseIdentifier: M_TitleHeader.identifire)
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: M_TitleHeader.identifire) as? M_TitleHeader else { return nil }
        headerView.configure(with: self)
        return headerView
    }
}

class M_TitleHeader: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleLabel: GradientLabel!
    @IBOutlet private weak var timeLeftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.gradientColors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
    }

    public func configure(with data: _TitleHeader) {
        titleLabel.text = data.title
        timeLeftLabel.text = data.timeLeft
    }
}
