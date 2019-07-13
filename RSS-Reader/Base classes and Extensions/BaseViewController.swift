//
//  BaseViewController.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 13/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var loaderVC:LoaderViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func showLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.hideLoader()
            if let vC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoaderViewControllerIdentifier") as? LoaderViewController {
                self?.loaderVC = vC
                self?.addChild(vC)
                self?.view.addSubview(self!.loaderVC!.view)
            }
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.loaderVC?.view.removeFromSuperview()
            self?.loaderVC?.removeFromParent()
        }
    }

}
