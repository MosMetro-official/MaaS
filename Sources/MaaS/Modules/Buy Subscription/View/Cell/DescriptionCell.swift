//
//  DescriptionCell.swift
//  MaaS
//
//  Created by Слава Платонов on 14.06.2022.
//

import UIKit
import CoreTableView
import SDWebImage

protocol _DescriptionCell: CellData {
    var title: String { get }
    var descr: String { get }
    var imageUrl: String { get }
}

extension _DescriptionCell {
    func hashValues() -> [Int] {
        return [title.hashValue, descr.hashValue, imageUrl.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? DescriptionCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(DescriptionCell.nib, forCellReuseIdentifier: DescriptionCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DescriptionCell.identifire, for: indexPath) as? DescriptionCell else { return .init() }
        return cell
    }
}

class DescriptionCell: UITableViewCell {
    
    @IBOutlet private weak var imageLogo: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with data: _DescriptionCell) {
        if let url = URL(string: data.imageUrl) {
            imageLogo.sd_setImage(with: url)
        } else {
            imageLogo.image = UIImage.getAssetImage(image: "transport")
        }
        titleLabel.text = data.title
        descrLabel.text = data.descr
    }
}
