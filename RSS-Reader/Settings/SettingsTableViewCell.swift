//
//  SettingsTableViewCell.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 23/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate: class {
    func switchStatusChanged(indexPath:IndexPath?)
}

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var statusSwitch: UISwitch!
    
    var indexPath:IndexPath?
    weak var delegate: SettingsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(data: SettingCellDataSource?) {
        titleLbl.text = data?.title
        statusSwitch.setOn(data?.switchStatus ?? false, animated: true)
    }

    @IBAction func switchStatusChanged(_ sender: UISwitch) {
        delegate?.switchStatusChanged(indexPath: indexPath)
    }
}
