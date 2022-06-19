//
//  MaaSCell.swift
//  MaaSExample
//
//  Created by Слава Платонов on 17.06.2022.
//

import UIKit
import MaaS

class MaaSCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var service: [M_Service]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    var action: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 10)
        collectionView.register(UINib(nibName: "TariffCell", bundle: nil), forCellWithReuseIdentifier: "colcell")
        [titleLabel, collectionView, button, cellTitleLabel].forEach { $0?.isHidden = true }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    private func getCurrentDate(from string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = "dd MMMM yyyy"
            dateFormatter.locale = .current
            return dateFormatter.string(from: date)
        }
        return "неизвестно"
    }
    
    private func setVisionAlpha() {
        self.titleLabel.alpha = 1
        self.cellTitleLabel.alpha = 1
        self.logoImage.alpha = 1
    }
    
    private func setHalvVisionAlpha() {
        titleLabel.alpha = 0.5
        cellTitleLabel.alpha = 0.5
        logoImage.alpha = 0.5
    }
    
    private func showLabels() {
        titleLabel.isHidden = false
        cellTitleLabel.isHidden = false
    }
    
    @IBAction func buttonPressed() {
        action?()
    }
    
    public func loadConfigure() {
        setHalvVisionAlpha()
        button.isHidden = true
        collectionView.isHidden = true
        logoImage.isHidden = true
        activity.startAnimating()
    }
    
    public func errorConfigure(title: String, action: @escaping () -> Void) {
        setVisionAlpha()
        showLabels()
        button.isHidden = false
        logoImage.isHidden = false
        collectionView.isHidden = true
        self.action = action
        titleLabel.text = title
        activity.stopAnimating()
        button.setTitle("Загрузить еще раз", for: .normal)
    }
    
    
    public func authConfig(with user: M_UserInfo) {
        guard let to = user.subscription?.valid?.to else { return }
        setVisionAlpha()
        showLabels()
        logoImage.isHidden = false
        button.isHidden = true
        collectionView.isHidden = false
        titleLabel.text = "\(user.paySystem) •••• \(user.maskedPan) до \(getCurrentDate(from: to))"
        service = user.subscription?.services
        activity.stopAnimating()
    }
    
    public func nonAuthConfigure(with action: @escaping () -> Void) {
        setVisionAlpha()
        showLabels()
        logoImage.isHidden = false
        button.isHidden = false
        collectionView.isHidden = true
        titleLabel.text = "Весь транспорт в одной подписке"
        self.action = action
        activity.stopAnimating()
        button.setTitle("Загрузить еще раз", for: .normal)
    }
}

extension MaaSCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = service?.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colcell", for: indexPath) as? TariffCell,
            let tariff = service?[indexPath.row] else { return .init() }
        cell.configure(with: tariff)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colcell", for: indexPath) as? TariffCell else { return .zero }
        let width = UIScreen.main.bounds.width / 3 + 20
        guard
            let titleHeight = cell.titleLabel.text?.height(withConstrainedWidth: cell.frame.width, font: UIFont.systemFont(ofSize: 11)),
            let tariffHeight = cell.tariffLabel.text?.height(withConstrainedWidth: cell.frame.width, font: UIFont.systemFont(ofSize: 13)) else { return .zero }
        return CGSize(width: width, height: titleHeight + tariffHeight + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
