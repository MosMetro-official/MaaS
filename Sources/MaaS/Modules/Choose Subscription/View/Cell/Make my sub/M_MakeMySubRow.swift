//
//  MakeMySubRow.swift
//  
//
//  Created by Слава Платонов on 29.04.2022.
//

import UIKit
import CoreTableView

protocol _MakeMySubRow: CellData {
    var title: String { get }
    var descr: String { get }
    var isSelect: Bool { get }
}

extension _MakeMySubRow {    
    func hashValues() -> [Int] {
        return [
            title.hashValue,
            descr.hashValue,
            isSelect.hashValue
        ]
    }
    
    func prepare(cell: UITableViewCell, for tableView: UITableView, indexPath: IndexPath) {
        guard let cell = cell as? M_MakeMySubRow else { return }
        cell.configure(with: self)
    }
    
    func cell(for tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        tableView.register(M_MakeMySubRow.nib, forCellReuseIdentifier: M_MakeMySubRow.identifire)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: M_MakeMySubRow.identifire, for: indexPath) as? M_MakeMySubRow else { return .init() }
        return cell
    }
}

class M_MakeMySubRow: UITableViewCell {
    
    var gradientHeight: CGFloat?
    var gradient: CAGradientLayer?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var selectImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.cornerRadius = 15
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor.systemGray.cgColor
        addGradient()
    }

    private func addGradient() {
        gradient?.removeFromSuperlayer()
        self.gradient = CAGradientLayer()
        guard let gradient = gradient else {
            return
        }
        gradient.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: cardView.bounds.width, height: gradientHeight ?? 0))
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
        titleLabel.text = data.title
        descriptionLabel.text = data.descr
        gradientHeight = data.height
        selectImage.image = data.isSelect ? UIImage.getAssetImage(image: "select") : UIImage.getAssetImage(image: "unselect")
        gradient?.isHidden = !data.isSelect
        cardView.layer.borderWidth = data.isSelect ? 0 : 1
        if data.isSelect {
            addGradient()
        }
    }
}
