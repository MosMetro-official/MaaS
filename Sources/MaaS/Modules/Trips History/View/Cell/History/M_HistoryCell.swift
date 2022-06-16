//
//  M_HistoryCell.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView

protocol _History: CellData {
    var title: String { get }
    var image: UIImage { get }
    var date: String { get }
}

extension _History {
    func hashValues() -> [Int] {
        return [
            title.hashValue,
            image.hashValue,
            date.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_HistoryCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_HistoryCell.nib, forCellReuseIdentifier: M_HistoryCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_HistoryCell.identifire, for: indexPath) as? M_HistoryCell else { return .init() }
        return cell
    }
}

class M_HistoryCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with data: _History) {
        titleLabel.text = data.title
        dateLabel.text = data.date
        logoImage.image = data.image
    }
    
}
