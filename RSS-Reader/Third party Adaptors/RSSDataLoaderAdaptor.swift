//
//  RSSDataLoaderAdaptor.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 29/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation
import RSSDataLoader

protocol RSSFeedAdaptorProtocol: RSSFeedProtocol {
    
}

protocol RSSFeedsAdaptorProtocol: RSSFeedsProtocol {
    
}

protocol RSSDataLoaderAdaptorProtocol: RSSDataLoaderProtocol {
    
}

class RSSFeedAdaptor: RSSFeedAdaptorProtocol {
    let feed:RSSFeedProtocol
    
    var feedDescription: String?{
        return feed.feedDescription
    }
    
    var redirectionUrl: String?{
        return feed.redirectionUrl
    }
    
    var title: String?{
        return feed.title
    }
    
    var pubDate: Date?{
        return feed.pubDate
    }
    
    var guid: String?{
        return feed.guid
    }
    
    var isDone: Bool{
        return feed.isDone
    }
    
    var isOpened: Bool{
        return feed.isOpened
    }
    
    var isUnWanted: Bool{
        return feed.isUnWanted
    }
    
    init(feed:RSSFeedProtocol) {
        self.feed = feed
    }
    
    static func convertTheFeed(feeds:NSSet?) -> NSSet? {
        let convertedFeeds = NSMutableSet()
        (feeds?.allObjects as? [RSSFeedProtocol])?.forEach({ (feed) in
            convertedFeeds.add(RSSFeedAdaptor(feed: feed))
        })
        
        return convertedFeeds
    }
}

class RSSFeedsAdaptor: RSSFeedsAdaptorProtocol {
    let feeds: RSSFeedsProtocol
    
    var title: String? {
        return feeds.title
    }
    
    var url: String? {
        return feeds.url
    }
    
    var feed: NSSet?
    
    init(feeds: RSSFeedsProtocol) {
        self.feeds = feeds
        feed = RSSFeedAdaptor.convertTheFeed(feeds: feeds.feed)
    }
}

class RSSDataLoaderAdaptor: FeedViewModelDataSource, SettingsViewModelDataSource, FeedDetailViewModelDataSource {
    static func deleteFeedDate(before: Date) {
        RSSDataLoader.deleteFeedDate(before: before)
    }
    
    static func getRSSFeeds() -> [RSSFeedsAdaptorProtocol] {
        var list:[RSSFeedsAdaptorProtocol] = []
        let feeds = RSSDataLoader.getRSSFeeds()
        
        for each in feeds {
            list.append(RSSFeedsAdaptor(feeds: each))
        }
        
        return list
    }
    
    static func addNewRSSFeed(url: String, title: String, callBack: RSSDataLoaderAdaptorProtocol) {
        return RSSDataLoader.addNewRSSFeed(url: url, title: title, callBack: callBack)
    }
    
    static func updateTheState(for feed: RSSFeedAdaptorProtocol, isDone: Bool?, isOpened: Bool?) {
        RSSDataLoader.updateTheState(for: feed, isDone: isDone, isOpened: isOpened)
    }
    
    static func deleteFeedData(guid: String) {
        RSSDataLoader.deleteFeedData(guid: guid)
    }
    
    static func updateTheFeed() {
        RSSDataLoader.updateTheFeed()
    }
    
    static func setTheCallBack(with inst: RSSDataLoaderAdaptorProtocol) {
        RSSDataLoader.setTheCallBack(with: inst)
    }
}
