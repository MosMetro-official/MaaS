//
//  M_HistoryCell.swift
//  MaaS
//
//  Created by Слава Платонов on 16.06.2022.
//

import UIKit
import CoreTableView
import SDWebImage


protocol _History: CellData {
    var title: String { get }
    var imageURL: URL? { get }
    var date: String { get }
    var route: String { get }
}

extension _History {
    func hashValues() -> [Int] {
        return [
            title.hashValue,
            imageURL.hashValue,
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
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var routeLabel: UILabel!
    
    private var imageURL: URL? {
        didSet {
            logoImage.sd_setImage(with: imageURL)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.logoImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.logoImage.layer.cornerCurve = .continuous
        self.logoImage.layer.cornerRadius = 10
    }
    
    public func configure(with data: _History) {
        titleLabel.text = data.title
        dateLabel.text = data.date
        routeLabel.text = data.route
        routeLabel.isHidden = data.route == ""
        self.imageURL = data.imageURL
    }
}
