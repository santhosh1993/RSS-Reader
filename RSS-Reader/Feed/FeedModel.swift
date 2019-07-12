//
//  FeedModel.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 12/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import Foundation
import RSSDataLoader

class FeedSource:FeedSectionHeaderDataSource {
    var imgName: String = ""
    
    let title: String
    
    let url: String
    
    var feed:[Feed] = []
    
    init(data:RSSFeedsProtocol) {
        title = data.title ?? ""
        url = data.url ?? ""
        self.updateFeed(rssFeed: (data.feed?.allObjects as? [RSSFeedProtocol] ?? []))
    }
    
    func updateFeed(rssFeed:[RSSFeedProtocol]) {
        for each in rssFeed {
            feed.append(Feed(feed: each))
        }
    }
}

class Feed {
    private var feed:RSSFeedProtocol
    
    init(feed: RSSFeedProtocol) {
        self.feed = feed
    }
    
}

extension Feed: RSSFeedProtocol{
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
}

extension Feed: FeedCellDataSource{
    var feedtitle: String {
        return feed.title ?? ""
    }
}


