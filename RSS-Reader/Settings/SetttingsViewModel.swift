//
//  SetttingsViewModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 23/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation

protocol SettingsViewModelDataSource: class {
   static func deleteFeedDate(before: Date)
}

protocol SettingsViewModelDelegate: class {
    func dataUpdated()
    func showAlert(title: String, message: String)
    func popTheController()
}

class SettingsViewModel {
    var sectionList:[Section] = []
    weak var delegate: SettingsViewModelDelegate?
    let dataSource: SettingsViewModelDataSource
    
    init(dataSource:  SettingsViewModelDataSource = RSSDataLoaderAdaptor()) {
        sectionList.append(DeleteRuleSection())
        self.dataSource = dataSource
    }
    
    func resetSatusOfSetting(index:Int) {
        if let section = sectionList[index] as? DeleteRuleSection{
            section.resetSatusOfSetting()
        }
    }
    
    func settingStatusChanged(indexPath: IndexPath) {
        if let section = sectionList[indexPath.section] as? DeleteRuleSection{
            section.settingStatusChanged(index: indexPath.row)
            delegate?.dataUpdated()
        }
    }
    
    func saveTheUpdatedSettings() {
        for each in sectionList {
            let result = each.saveTheSettings()
            if let result = result as? DeleteRule {
                type(of: dataSource).deleteFeedDate(before: result.getDate())
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.popTheController()
                    self?.delegate?.showAlert(title: "Data Got Deleted", message: "Feed with less than \(result.inDays()) got deleted")
                }
            }
        }
    }
}

extension SettingsViewModel: SettingsViewDataSource {
    var sections: [SettingSectionDataSource] {
        return sectionList
    }
}
