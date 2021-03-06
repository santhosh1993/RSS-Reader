//
//  FeedDetailViewModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 14/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation

protocol FeedDetailViewModelDataSource {
    static func updateTheState(for: RSSFeedAdaptorProtocol, isDone: Bool?, isOpened: Bool?)
}

protocol FeedDetailViewModelDelegate: class {
    func loadRequest(url: URL)
    func unLoadErrorView(isHidden: Bool)
    func showLoader()
    func hideLoader()
    func popTheViewController()
    func reloadData()
    func addNotes(title:String, description: String,key: String)
}

class FeedDetailViewModel {
    var feed:Feed?
    
    weak var delegate: FeedDetailViewModelDelegate?
    var dataSource: FeedDetailViewModelDataSource
    
    init(dataSource: FeedDetailViewModelDataSource = RSSDataLoaderAdaptor()) {
        self.dataSource = dataSource
    }
    
    func setTheFeed(feed:Feed?) {
        self.feed = feed
    }
    
    func doneBtnTapped() {
        if let feed = feed {
            type(of: dataSource).updateTheState(for: feed, isDone: true, isOpened: true)
        }
        delegate?.popTheViewController()
    }
    
    func feedGotUpdated(){
        if let url = URL(string: feed?.redirectionUrl ?? feed?.guid ?? "") {
            delegate?.showLoader()
            delegate?.loadRequest(url: url)
        }
        else{
            delegate?.unLoadErrorView(isHidden: false)
        }
    }
    
    func urlIsLoaded(){
        delegate?.hideLoader()
    }
    
    func urlFailedToLoad() {
        delegate?.hideLoader()
        delegate?.unLoadErrorView(isHidden: false)
    }
    
    func shakeGestureDetected(){
        delegate?.reloadData()
    }
    
    func addNotesButtonTapped() {
        delegate?.addNotes(title: feed?.title ?? "", description: feed?.feedDescription ?? "",key:  feed?.redirectionUrl ?? feed?.guid ?? "")
    }
}
