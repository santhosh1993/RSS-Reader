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

class FeedViewController: BaseViewController {

    let viewModel: FeedViewModel = FeedViewModel()
    var feed: Feed?
    
    @IBOutlet var feedView: FeedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        feedView.delegate = self
        feedView.dataSource = viewModel
        RSSFeeder.authenticateTheUser(callBack: viewModel)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New RSS feed url", message: "", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "RSS Title"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "RSS Feed URL"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {[weak self] alert -> Void in
            let titleTF = alertController.textFields![0] as UITextField
            let urlTF = alertController.textFields![1] as UITextField
            
            self?.viewModel.addNewRSSFeed(title: titleTF.text ?? "", url: urlTF.text ?? "")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FeedDetailViewController {
            vc.feed = feed
        }
    }
    
}

extension FeedViewController: FeedViewModelDelegate{
    
    func pushTheFeedDetailView(feed: Feed) {
        self.feed = feed
        performSegue(withIdentifier: "FeedListToFeedDetailViewIdentifier", sender: self)
    }
    
    func reloadData() {
        feedView.reloadData()
    }
}

extension FeedViewController: FeedViewDelegate {
    func expandBtnTapped(section: Int) {
        viewModel.expandedBtnTapped(section: section)
    }
    
    func itemDidSelect(indexPath: IndexPath) {
        viewModel.itemSelected(indexPath: indexPath)
    }
}
