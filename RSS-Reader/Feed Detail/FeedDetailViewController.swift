//
//  FeedDetailViewController.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 13/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit
import WebKit

class FeedDetailViewController: BaseViewController {
    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var loadErrorView: UILabel!
    @IBOutlet weak var farwordButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var viewModel: FeedDetailViewModel = FeedDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    
        webVw.uiDelegate = self
        webVw.navigationDelegate = self
        viewModel.feedGotUpdated()
        // Do any additional setup after loading the view.
    }
    
    func feedForDetail(_ feed: Feed?){
        viewModel.setTheFeed(feed: feed)
    }

    @IBAction func doneBtnTapped(_ sender: UIBarButtonItem) {
        viewModel.doneBtnTapped()
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        if (webVw.canGoBack){
            webVw.goBack()
        }
        else{
            popTheViewController()
        }
    }
    
    @IBAction func farwordButtonTapped(_ sender: UIBarButtonItem) {
        webVw.goForward()
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        webVw.reload()
    }
    
    @IBAction func launchSafariApp(_ sender: UIButton) {
        if let url = webVw.url{
            UIApplication.shared.open(url) { (status) in
                
            }
        }
    }
    
    override func shakeGestureDetected() {
        viewModel.shakeGestureDetected()
    }
}

extension FeedDetailViewController : FeedDetailViewModelDelegate {
    func popTheViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func unLoadErrorView(isHidden: Bool) {
        loadErrorView.isHidden = isHidden
    }
    
    func loadRequest(url: URL) {
        let request = URLRequest.init(url: url)
        webVw.load(request)
    }
    
    func reloadData() {
        webVw.reload()
    }
}

extension FeedDetailViewController: WKUIDelegate{
    
}

extension FeedDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadErrorView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        viewModel.urlIsLoaded()
    }
}
