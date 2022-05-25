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
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_HeaderTableCell.nib, forCellReuseIdentifier: M_HeaderTableCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_HeaderTableCell.identifire, for: indexPath) as? M_HeaderTableCell else { return .init() }
        return cell
    }
}


class M_HeaderTableCell: UITableViewCell {
    //TODO: header
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
