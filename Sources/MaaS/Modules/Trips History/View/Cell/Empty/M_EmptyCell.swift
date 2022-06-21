//
//  M_EmptyCell.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView

protocol _Empty: CellData { }

extension _Empty {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_EmptyCell.nib, forCellReuseIdentifier: M_EmptyCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_EmptyCell.identifire, for: indexPath) as? M_EmptyCell else { return .init() }
        return cell
    }
}

class M_EmptyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
