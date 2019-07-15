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
            self?.removeTheLoader()
            if let vC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoaderViewControllerIdentifier") as? LoaderViewController {
                self?.loaderVC = vC
                self?.addChild(vC)
                self?.view.addSubview(self!.loaderVC!.view)
                self?.view.bringSubviewToFront(self!.loaderVC!.view)
            }
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async { [weak self] in
            self?.removeTheLoader()
        }
    }
    
    private func removeTheLoader(){
        loaderVC?.view.removeFromSuperview()
        loaderVC?.removeFromParent()
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            shakeGestureDetected()
        }
    }
    
    func shakeGestureDetected(){
        
    }
}
