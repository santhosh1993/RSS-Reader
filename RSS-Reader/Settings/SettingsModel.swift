//
//  SettingsModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 24/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation

enum DeleteRule: String{
    case oneWeek = "One Week"
    case oneMonth = "One Month"
    case threeMonths = "Three Months"
    
    static func allCases() -> [String] {
        return [DeleteRule.oneWeek.rawValue,DeleteRule.oneMonth.rawValue,DeleteRule.threeMonths.rawValue]
    }
    
    static func selectedState() -> DeleteRule? {
        return DeleteRule(rawValue: UserDefaults.standard.string(forKey: "selectedState") ?? "")
    }
    
    static func resetSelectedState() {
        UserDefaults.standard.set("", forKey: "selectedState")
    }
    
    func setSelectedState() {
        UserDefaults.standard.set(self.rawValue, forKey: "selectedState")
    }
    
    func inDays() -> String {
        switch self {
        case .oneWeek:
            return "7 days"
        case .oneMonth:
            return "30 days"
        case .threeMonths:
            return "90 days"
        }
    }
    
    func getDate() -> Date {
        let timeIntevalForADay =  24 * 60 * 60
        switch self {
        case .oneWeek:
            return Date().addingTimeInterval(TimeInterval(-7 * timeIntevalForADay))
        case .oneMonth:
            return Date().addingTimeInterval(TimeInterval(-30 * timeIntevalForADay))
        case .threeMonths:
            return Date().addingTimeInterval(TimeInterval(-90 * timeIntevalForADay))
        }
    }
}

class Setting:SettingCellDataSource {
    var title: String
    var switchStatus: Bool
    
    init(title: String, switchStatus: Bool) {
        self.title = title
        self.switchStatus = switchStatus
    }
}

class Section {
    var title:String
    var settingList:[Setting]
    
    init(title:String) {
        self.title = title
        settingList = []
    }
    
    func saveTheSettings() -> Any? {
        return nil
    }
}

extension Section: SettingSectionDataSource{
    var settings: [SettingCellDataSource] {
        return settingList
    }
}

class DeleteRuleSection: Section {
    init() {
        super.init(title: "Delete Rule")

        let rule = DeleteRule.selectedState()?.rawValue ?? ""
        
        for each in DeleteRule.allCases() {
            let setting = Setting(title: each, switchStatus: (each == rule))
            settingList.append(setting)
        }
    }
    
    override func saveTheSettings() -> Any? {
        DeleteRule.resetSelectedState()
        for each in settingList{
            if each.switchStatus {
                let rule = DeleteRule(rawValue: each.title)
                rule?.setSelectedState()
                return rule
            }
        }
        
        return nil
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
    }
}
