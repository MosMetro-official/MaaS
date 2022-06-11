//
//  SupportCell.swift
//  MaaS
//
//  Created by Слава Платонов on 11.06.2022.
//

import UIKit
import CoreTableView

protocol _SupportCell: CellData { }

extension _SupportCell {
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(SupportCell.nib, forCellReuseIdentifier: SupportCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SupportCell.identifire, for: indexPath) as? SupportCell else { return .init() }
        return cell
    }
}

class SupportCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
