//
//  SettingsViewController.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 23/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var settingsView: SettingsView!
    let viewModel = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsView.delegate = self
        settingsView.dataSource = viewModel
        viewModel.delegate = self
        settingsView.updateUI()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SettingsViewController: SettingsViewDelegate {
    func switchStatusChanged(index: Int) {
        viewModel.settingStatusChanged(index: index)
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func dataUpdated() {
        settingsView.updateUI()
    }
}
