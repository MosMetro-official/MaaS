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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cellTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    var service: [M_Tariff]? {
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
        [titleLabel, collectionView, button, cellTitleLabel, logoImage ].forEach { $0?.isHidden = true }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
    }
    
    private func setVisionAlpha() {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.titleLabel.alpha = 1
            self.dateLabel.alpha = 1
            self.cellTitleLabel.alpha = 1
            self.logoImage.alpha = 1
        }
        animator.startAnimation()
    }
    
    private func setHalvVisionAlpha() {
        let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut) {
            self.titleLabel.alpha = 0.5
            self.dateLabel.alpha = 0.5
            self.cellTitleLabel.alpha = 0.5
            self.logoImage.alpha = 0.5
        }
        animator.startAnimation()
    }
    
    private func showLabels() {
        titleLabel.isHidden = false
        dateLabel.isHidden = false
        cellTitleLabel.isHidden = false
    }
    
    @IBAction func buttonPressed() {
        action?()
    }
    
    public func loadConfigure() {
        setHalvVisionAlpha()
        button.isHidden = true
        dateLabel.isHidden = true
        collectionView.isHidden = true
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
        dateLabel.text = nil
        activity.stopAnimating()
        button.setTitle("Загрузить еще раз", for: .normal)
    }
    
    public func authProccessingConfig(message: String, action: @escaping () -> Void) {
        titleLabel.text = message
        dateLabel.text = ""
        showLabels()
        setVisionAlpha()
        button.isHidden = false
        logoImage.isHidden = false
        button.setTitle("Проверить статус", for: .normal)
        collectionView.isHidden = true
        self.action = action
        activity.stopAnimating()
    }
    
    
    public func authConfig(with user: M_UserInfo, action: @escaping () -> Void) {
        guard let to = user.subscription?.valid?.to else { return }
        setVisionAlpha()
        showLabels()
        logoImage.isHidden = false
        button.isHidden = true
        collectionView.isHidden = false
        self.action = action
        guard let paySystem = user.paySystem?.rawValue else { return }
        titleLabel.text = "\(paySystem) •••• \(user.maskedPan)"
        dateLabel.text = "До \(M_DateConverter.validateStringFrom(date: to))"
        service = user.subscription?.tariffs
        activity.stopAnimating()
    }
    
    public func nonAuthConfigure(message: String, and action: @escaping () -> Void) {
        setVisionAlpha()
        showLabels()
        logoImage.isHidden = false
        button.isHidden = false
        collectionView.isHidden = true
        titleLabel.text = message
        dateLabel.text = nil
        self.action = action
        activity.stopAnimating()
        button.setTitle("Попробовать", for: .normal)
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
        let width = UIScreen.main.bounds.width / 3 + 30
        let tariff = service?[indexPath.row]
        let titleHeight = tariff?.name.ru.height(
            withConstrainedWidth: width,
            font: UIFont.systemFont(ofSize: 11)
        ) ?? 0
        let descrHeight = tariff?.trip.countDescr.height(
            withConstrainedWidth: width,
            font: UIFont.systemFont(ofSize: 13)
        ) ?? 0
        return CGSize(width: width, height: titleHeight + descrHeight + 20)
    }
}
