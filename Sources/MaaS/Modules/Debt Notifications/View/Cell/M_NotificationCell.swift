//
//  M_NotificationCell.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView

protocol _Notification: CellData {
    var title: String { get }
    var descr: String { get }
}

extension _Notification {
    
    func hashValues() -> [Int] {
        return [title.hashValue, descr.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_NotificationCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_NotificationCell.nib, forCellReuseIdentifier: M_NotificationCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_NotificationCell.identifire, for: indexPath) as? M_NotificationCell else { return .init() }
        return cell
    }
}

class M_NotificationCell: UITableViewCell {

    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with data: _Notification) {
        titleLabel.text = data.title
        descrLabel.text = data.descr
    }
}
