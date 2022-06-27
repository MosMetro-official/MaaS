//
//  M_StatusInfoCell.swift
//  MaaS
//
//  Created by Слава Платонов on 26.06.2022.
//

import UIKit
import CoreTableView

protocol _StatusInfoCell: CellData {
    var title: String { get }
    var descr: String { get }
    var imageStatus: UIImage { get }
    var onAction: Command<Void>? { get }
    var actionTitle: String { get }
}

extension _StatusInfoCell {
    
    var onAction: Command<Void>? {
        return nil
    }
    
    func hashValues() -> [Int] {
        return [title.hashValue, descr.hashValue, imageStatus.hashValue, actionTitle.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_StatusInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_StatusInfoCell.nib, forCellReuseIdentifier: M_StatusInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_StatusInfoCell.identifire, for: indexPath) as? M_StatusInfoCell else { return .init() }
        return cell
    }
}

class M_StatusInfoCell: UITableViewCell {

    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descrLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    private var onAction: Command<Void>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        actionButton.titleLabel?.font = Appearance.getFont(.button)
    }
    
    @IBAction func actionButtonPressed() {
        onAction?.perform(with: ())
    }
    
    public func configure(with data: _StatusInfoCell) {
        logoImage.image = data.imageStatus
        titleLabel.text = data.title
        descrLabel.text = data.descr
        if data.onAction != nil {
            actionButton.isHidden = false
            actionButton.setTitle(data.actionTitle, for: .normal)
        }
        onAction = data.onAction
    }
}
