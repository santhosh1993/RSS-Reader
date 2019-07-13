//
//  LoaderViewController.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 13/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class LoaderViewController: UIViewController {
    
    @IBOutlet var loaderView: UIView!
    @IBOutlet weak var animationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func bacgroundViewTapped(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false) {
            
        }
    }
}
