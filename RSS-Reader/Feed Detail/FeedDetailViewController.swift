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
    var feed:Feed?
    @IBOutlet weak var webVw: WKWebView!
    @IBOutlet weak var loadErrorView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webVw.uiDelegate = self
        webVw.navigationDelegate = self
        DispatchQueue.main.async {[weak self] in
            self?.loadRequest()
        }
        // Do any additional setup after loading the view.
    }
    
    func loadRequest() {
        if let url = URL.init(string: feed?.redirectionUrl ?? "") {
            showLoader()
            let request = URLRequest.init(url: url)
            webVw.load(request)
        }
        else {
            loadErrorView.isHidden = false
        }
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

extension FeedDetailViewController: WKUIDelegate{
    
}

extension FeedDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadErrorView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }
}
