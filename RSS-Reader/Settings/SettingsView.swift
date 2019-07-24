//
//  SettingsView.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 23/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit


protocol SettingCellDataSource {
    var title:String {get}
    var switchStatus:Bool {get}
}

protocol SettingSectionDataSource {
    var title:String{get}
    var settings:[SettingCellDataSource] {get}
}

protocol SettingsViewDataSource: class {
    var sections:[SettingSectionDataSource] {get}
}

protocol  SettingsViewDelegate: class{
    func switchStatusChanged(indexPath: IndexPath)
}

class SettingHeaderView : UITableViewHeaderFooterView {
    static let reuseIdentifier = "SettingHeaderIdentifier"
    
    var titleLbl : UILabel = UILabel.init(frame: CGRect(x: 10,y: 0,width: 0,height: 0))
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        titleLbl.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        self.addSubview(titleLbl)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTitle(title:String) {
        titleLbl.text = title
    }
}

class SettingsView: UIView {

    @IBOutlet weak var settingsTableView: UITableView!
    
    weak var dataSource: SettingsViewDataSource?
    weak var delegate: SettingsViewDelegate?
    
    override func awakeFromNib() {
        settingsTableView.register(SettingHeaderView.self, forHeaderFooterViewReuseIdentifier: SettingHeaderView.reuseIdentifier)
    }
    
    func updateUI() {
        settingsTableView.reloadData()
    }

}

extension SettingsView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.sections.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.sections[section].settings.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingHeaderIdentifier") as? SettingHeaderView {
            headerview.setTitle(title: dataSource?.sections[section].title ?? "")
            return headerview
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCellIdentifier", for: indexPath) as! SettingsTableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.updateUI(data: dataSource?.sections[indexPath.section].settings[indexPath.row])
        
        return cell
    }
}

extension SettingsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switchStatusChanged(indexPath: indexPath)
    }
}

extension SettingsView: SettingsTableViewCellDelegate {
    func switchStatusChanged(indexPath: IndexPath?) {
        if let indexPath = indexPath {
            delegate?.switchStatusChanged(indexPath: indexPath)
        }
    }
}
