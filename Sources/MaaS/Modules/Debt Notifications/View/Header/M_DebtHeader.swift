//
//  M_DebtHeader.swift
//  MaaS
//
//  Created by Слава Платонов on 19.07.2022.
//

import UIKit
import CoreTableView

protocol _HeaderNotification: HeaderData { }

extension _HeaderNotification {
    func header(for tableView: UITableView, section: Int) -> UIView? {
        tableView.register(M_DebtHeader.nib, forHeaderFooterViewReuseIdentifier: M_DebtHeader.identifire)
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: M_DebtHeader.identifire) as? M_DebtHeader else { return nil }
        return header
    }
}

class M_DebtHeader: UITableViewHeaderFooterView {
    
    @IBOutlet private var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.setLineSpacing(lineSpacing: 5, lineHeightMultiple: 1)
        titleLabel.font = Appearance.getFont(.smallBody)
        titleLabel.text = "Здесь мы покажем важные уведомления о вашей подписке"
    }

}
