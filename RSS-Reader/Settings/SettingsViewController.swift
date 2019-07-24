//
//  SettingsViewController.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 23/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

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

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        viewModel.saveTheUpdatedSettings()
    }
    
}

extension SettingsViewController: SettingsViewDelegate {
    func switchStatusChanged(indexPath: IndexPath) {
        viewModel.settingStatusChanged(indexPath: indexPath)
    }
}

extension SettingsViewController: SettingsViewModelDelegate {
    func dataUpdated() {
        settingsView.updateUI()
    }
    
    func popTheController() {
        navigationController?.popViewController(animated: true)
    }
}
