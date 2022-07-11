//
//  M_SupportCell.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import UIKit
import CoreTableView

protocol _SupportCell: CellData { }

extension _SupportCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_SupportCell.nib, forCellReuseIdentifier: M_SupportCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_SupportCell.identifire, for: indexPath) as? M_SupportCell else { return .init() }
        return cell
    }
}

class M_SupportCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
