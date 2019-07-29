//
//  FeedModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 12/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation

class FeedSource:FeedSectionHeaderDataSource {
    var imgName: String = "arrowDown"
    let title: String
    let url: String
    var feed:[Feed] = []
    var isExpanded = false {
        didSet{
            imgName = (isExpanded) ? "arrowUp" : "arrowDown"
        }
    }
    
    init(data:RSSFeedsAdaptorProtocol, filter:((RSSFeedAdaptorProtocol) -> Bool)) {
        title = data.title ?? ""
        url = data.url ?? ""
        
        let feedArray = (data.feed?.allObjects as? [RSSFeedAdaptorProtocol])?.filter({ (object) -> Bool in
            return filter(object)
        })
        
        self.updateFeed(rssFeed: feedArray ?? [])
    }
    
    func updateFeed(rssFeed:[RSSFeedAdaptorProtocol]) {
        for each in rssFeed {
            feed.append(Feed(feed: each))
        }
    }
}

class Feed {
    private var feed:RSSFeedAdaptorProtocol
    
    init(feed: RSSFeedAdaptorProtocol) {
        self.feed = feed
    }
    
}

extension Feed: RSSFeedAdaptorProtocol{
    var feedDescription: String? {
        return feed.feedDescription
    }
    
    var redirectionUrl: String? {
        return feed.redirectionUrl
    }
    
    var title: String? {
        return feed.title
    }
    
    var pubDate: Date? {
        return feed.pubDate
    }
    
    var guid: String? {
        return feed.guid
    }
    
    var isDone: Bool {
        return feed.isDone
    }
    
    var isOpened: Bool {
        return feed.isOpened
    }
    
    var isUnWanted: Bool {
        return feed.isUnWanted
    }
}

extension Feed: FeedCellDataSource{
    var feedtitle: String {
        return feed.title ?? ""
    }
}


