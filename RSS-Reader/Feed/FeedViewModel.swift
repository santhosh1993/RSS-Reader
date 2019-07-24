//
//  FeedViewModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 11/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation
import RSSFeederLogin
import RSSDataLoader

protocol FeedViewModelDelegate: class {
    func reloadData()
    func showLoader()
    func hideLoader()
    func pushTheFeedDetailView(feed:Feed)
}

class FeedViewModel {
    weak var delegate:FeedViewModelDelegate?
    var segmentState: SegmentState = SegmentState.New
    
    var rssFeeds:[FeedSource] = []
    
    init() {
        if let date = DeleteRule.selectedState()?.getDate(){
            RSSDataLoader.deleteFeedDate(before: date)
        }
    }
    
    func getTheFeed() {
        rssFeeds = []
        let feeds = RSSDataLoader.getRSSFeeds()
        
        for each in feeds {
            let source = FeedSource(data: each, filter: { (object) in
                switch segmentState {
                case .New:
                    return !(object.isOpened || object.isDone)
                case .Finished:
                    return object.isDone
                case .Reading:
                    return object.isOpened && !object.isDone
                }
            })
            
            if (source.feed.count > 0){
                rssFeeds.append(source)
            }
        }
        
        rssFeeds.first?.isExpanded = true
    }
    
    func expandedBtnTapped(section:Int){
        rssFeeds[section].isExpanded = !rssFeeds[section].isExpanded
        delegate?.reloadData()
    }
    
    func addNewRSSFeed(title:String, url:String) {
        RSSDataLoader.addNewRSSFeed(url: url, title: title, callBack: self)
    }
    
    func itemSelected(indexPath:IndexPath) {
        let feed = rssFeeds[indexPath.section].feed[indexPath.row]
        RSSDataLoader.updateTheState(for: feed, isDone: nil, isOpened: true)
        delegate?.pushTheFeedDetailView(feed: feed)
    }
    
    func segmentStateChanged(state: SegmentState) {
        segmentState = state
        getTheFeed()
        delegate?.reloadData()
    }
    
    func shakeGestureDetected() {
        refeshTheData()
    }
    
    private func refeshTheData() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.showLoader()
            RSSDataLoader.setTheCallBack(with: self!)
            RSSDataLoader.updateTheFeed()
        }
    }
}

extension FeedViewModel: RSSFeederLoginCallBack{
    func errorOccuredWhileAuthenticating() {
        
    }
    
    func userSuccessfullyAuthenticated() {
        refeshTheData()
    }
}

extension FeedViewModel: RSSDataLoaderProtocol{
    func completion(status: Bool) {
        dataGotUpdated()
    }
    
    func dataGotUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.showLoader()
            self?.getTheFeed()
            self?.delegate?.reloadData()
            self?.delegate?.hideLoader()
        }
    }
}

extension FeedViewModel: FeedViewDataSource {
    
    var numberOfSections: Int {
        return rssFeeds.count
    }
    
    func numberOfRows(for section: Int) -> Int {
        let source = rssFeeds[section]
        return (source.isExpanded) ? source.feed.count : 0
    }
    
    func getDataForRow(for indexPath: IndexPath) -> FeedCellDataSource {
        return rssFeeds[indexPath.section].feed[indexPath.row]
    }
    
    func getDataForSectionHeader(for section: Int) -> FeedSectionHeaderDataSource {
        return rssFeeds[section]
    }
}

