//
//  HeaderTableCell.swift
//  
//
//  Created by Слава Платонов on 02.05.2022.
//

import UIKit
import CoreTableView

protocol _HeaderTableCell: CellData { }

extension _HeaderTableCell {
    var height: CGFloat {
        return 40
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(HeaderTableCell.nib, forCellReuseIdentifier: HeaderTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableCell.identifire, for: indexPath) as? HeaderTableCell else { return .init() }
        return cell
    }
}


class HeaderTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "MoscowSans-bold", size: 20)
    }
}
