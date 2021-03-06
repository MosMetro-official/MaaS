//
//  CardInfoCell.swift
//  
//
//  Created by Слава Платонов on 01.05.2022.
//

import UIKit
import CoreTableView


protocol _CardInfo: CellData {
    var cardImage: PaySystem { get }
    var cardNumber: String { get }
    var cardDescription: String { get }
    var leftCountChangeCard: String { get }
    var isUpdate: Bool { get }
}

extension _CardInfo {
    func hashValues() -> [Int] {
        return [
            cardImage.hashValue,
            cardNumber.hashValue,
            cardDescription.hashValue,
            leftCountChangeCard.hashValue,
            isUpdate.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_CardInfoCell else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_CardInfoCell.nib, forCellReuseIdentifier: M_CardInfoCell.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_CardInfoCell.identifire, for: indexPath) as? M_CardInfoCell else { return .init() }
        return cell
    }
}

class M_CardInfoCell: UITableViewCell {
    
    @IBOutlet private weak var cardImage: UIImageView!
    @IBOutlet private weak var cardNumberLabel: UILabel!
    @IBOutlet private weak var cardDescriptionLabel: UILabel!
    @IBOutlet private weak var leftCountLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    private func setLoadingState(isUpdate: Bool) {
        self.isUserInteractionEnabled = !isUpdate
        let animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut) { [weak self] in
            [self?.cardImage, self?.cardNumberLabel, self?.cardDescriptionLabel, self?.leftCountLabel].forEach { $0?.alpha = isUpdate ? 0.5 : 1 }
            isUpdate ? self?.activity.startAnimating() : self?.activity.stopAnimating()
        }
        animator.startAnimation()
    }
    
    public func configure(with data: _CardInfo) {
        setLoadingState(isUpdate: data.isUpdate)
        cardImage.image = UIImage.getCardHolderImage(for: data.cardImage)
        cardNumberLabel.text = data.cardNumber
        cardDescriptionLabel.text = data.cardDescription
        leftCountLabel.text = data.leftCountChangeCard
    }
}
