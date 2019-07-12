//
//  FeedViewController.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 11/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit
import RSSFeederLogin
import RSSDataLoader

class FeedViewController: UIViewController {

    let viewModel: FeedViewModel = FeedViewModel()
    
    @IBOutlet var feedView: FeedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        feedView.delegate = self
        feedView.dataSource = viewModel
        RSSFeeder.authenticateTheUser(callBack: viewModel)
        
        // Do any additional setup after loading the view.
    }


}

extension FeedViewController: FeedViewModelDelegate{
    func reloadData() {
        feedView.reloadData()
    }
    
    func loader(show: Bool) {
        
    }
}

extension FeedViewController: FeedViewDelegate {
    
}
