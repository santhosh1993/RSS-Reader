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
    func loader(show:Bool)
}

class FeedViewModel {
    weak var delegate:FeedViewModelDelegate?
    
    var rssFeeds:[FeedSource] = []
    
    func getTheFeed() {
        rssFeeds = []
        let feeds = RSSDataLoader.getRSSFeeds()
        for each in feeds {
            rssFeeds.append(FeedSource(data: each))
        }
    }
    
    func expandedBtnTapped(section:Int){
        rssFeeds[section].isExpanded = !rssFeeds[section].isExpanded
        delegate?.reloadData()
    }
}

extension FeedViewModel: RSSFeederLoginCallBack{
    func errorOccuredWhileAuthenticating() {
        
    }
    
    func userSuccessfullyAuthenticated() {
        RSSDataLoader.setTheCallBack(with: self)
        RSSDataLoader.updateTheFeed()
    }
}

extension FeedViewModel: RSSDataLoaderProtocol{
    func completion(status: Bool) {
        
    }
    
    func dataGotUpdated() {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.loader(show: true)
            self?.getTheFeed()
            self?.delegate?.reloadData()
            self?.delegate?.loader(show: false)
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

