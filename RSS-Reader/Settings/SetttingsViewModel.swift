//
//  SetttingsViewModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 23/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation

protocol SettingsViewModelDelegate: class {
    func dataUpdated()
}

class Setting:SettingCellDataSource {
    var title: String
    var switchStatus: Bool
    
    init(title: String, switchStatus: Bool) {
        self.title = title
        self.switchStatus = switchStatus
    }
}

class SettingsViewModel {
    var settingList:[Setting] = []
    weak var delegate: SettingsViewModelDelegate?
    init() {
        for i in 0...5{
            let setting = Setting(title: "\(i)", switchStatus: false)
            settingList.append(setting)
        }
    }
    
    func resetSatusOfSetting() {
        for each in settingList {
            each.switchStatus = false
        }
    }
    
    func settingStatusChanged(index: Int) {
        if settingList[index].switchStatus {
            settingList[index].switchStatus = false
        }
        else{
            resetSatusOfSetting()
            settingList[index].switchStatus = true
        }
        
        delegate?.dataUpdated()
    }
}

extension SettingsViewModel: SettingsViewDataSource {
    var settings: [SettingCellDataSource] {
        return settingList
    }
}
