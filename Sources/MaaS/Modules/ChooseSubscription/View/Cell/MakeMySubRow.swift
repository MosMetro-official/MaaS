//
//  MakeMySubRow.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

protocol _MakeMySubRow: CellData {
    var isSelect: Bool { get }
}

extension _MakeMySubRow {
    var height: CGFloat {
        return 100
    }
    
    func hashValues() -> [Int] {
        return [isSelect.hashValue]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? MakeMySubRow else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(MakeMySubRow.nib, forCellReuseIdentifier: MakeMySubRow.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MakeMySubRow.identifire, for: indexPath) as? MakeMySubRow else { return .init() }
        return cell
    }
}

class MakeMySubRow: UITableViewCell {
    
    var gradient: CAGradientLayer?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "MoscowSans-bold", size: 20)
        descriptionLabel.font = UIFont(name: "MoscowSans-regular", size: 13)
        cardView.layer.cornerRadius = 15
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray.cgColor
        contentView.layer.cornerRadius = 15
        addGradient()
    }

    private func addGradient() {
        self.gradient = CAGradientLayer()
        guard let gradient = gradient else {
            return
        }
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: .init(width: UIScreen.main.bounds.width - 32, height: frame.height - 20))
        gradient.colors = [UIColor.from(hex: "#4AC7FA").cgColor, UIColor.from(hex: "#E649F5").cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 1.5
        shape.path =  UIBezierPath(roundedRect: CGRect(origin: .zero, size: gradient.frame.size).insetBy(dx: 1, dy: 1.5), cornerRadius: 15).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        cardView.layer.addSublayer(gradient)
    }
    
    public func configure(with data: _MakeMySubRow) {
        selectImage.image = data.isSelect ? UIImage.getAssetImage(image: "select") : UIImage.getAssetImage(image: "unselect")
        gradient?.isHidden = data.isSelect ? false : true
        cardView.layer.borderWidth = data.isSelect ? 0 : 1
    }
}
