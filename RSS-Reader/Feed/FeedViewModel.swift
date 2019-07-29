//
//  FeedViewModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 11/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation
import RSSFeederLogin

protocol FeedViewModelDataSource: class {
    static func deleteFeedDate(before: Date)
    static func getRSSFeeds() -> [RSSFeedsAdaptorProtocol]
    static func addNewRSSFeed(url:String, title:String, callBack:RSSDataLoaderAdaptorProtocol)
    static func updateTheState(for feed:RSSFeedAdaptorProtocol,isDone :Bool? ,isOpened:Bool? )
    static func deleteFeedData(guid: String)
    static func updateTheFeed()
    static func setTheCallBack(with inst:RSSDataLoaderAdaptorProtocol)
}

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
    var feedDataSource:FeedViewModelDataSource
    
    init(feedDataSource:FeedViewModelDataSource = RSSDataLoaderAdaptor()) {
        self.feedDataSource = feedDataSource

        if let date = DeleteRule.selectedState()?.getDate(){
            type(of: feedDataSource).deleteFeedDate(before: date)
        }
    }
    
    func getTheFeed() {
        rssFeeds = []
        let feeds = type(of: feedDataSource).getRSSFeeds()
        
        for each in feeds {
            let source = FeedSource(data: each, filter: { (object) in
                switch segmentState {
                case .New:
                    return !(object.isOpened || object.isDone || object.isUnWanted)
                case .Finished:
                    return object.isDone && !object.isUnWanted
                case .Reading:
                    return object.isOpened && !object.isDone && !object.isUnWanted
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
        type(of: feedDataSource).addNewRSSFeed(url: url, title: title, callBack: self)
    }
    
    func itemSelected(indexPath:IndexPath) {
        let feed = rssFeeds[indexPath.section].feed[indexPath.row]
        type(of: feedDataSource).updateTheState(for: feed, isDone: nil, isOpened: true)
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
    
    func deleteData(indexPath: IndexPath) {
        if let guid = rssFeeds[indexPath.section].feed[indexPath.row].guid {
            type(of: feedDataSource).deleteFeedData(guid: guid)
        }
    }
    
    private func refeshTheData() {
        DispatchQueue.main.async { [weak self] in
            if let ref = self {
                ref.delegate?.showLoader()
                type(of: ref.feedDataSource).setTheCallBack(with: self!)
                type(of: ref.feedDataSource).updateTheFeed()
            }
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

extension FeedViewModel: RSSDataLoaderAdaptorProtocol{
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

