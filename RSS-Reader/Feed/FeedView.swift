//
//  FeedView.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 11/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

enum SegmentState:Int {
    case New = 0
    case Reading = 1
    case Finished = 2
}

protocol FeedCellDataSource {
    var feedtitle:String {get}
}

protocol FeedSectionHeaderDataSource {
    var title:String{get}
    var imgName:String{get}
}

protocol  FeedSectionHeaderDelegate{
    func expandBtnTapped(section: Int)
}

protocol FeedViewDataSource: class  {
    var numberOfSections:Int{get}
    var segmentState:SegmentState{get}
    func numberOfRows(for section:Int) -> Int
    func getDataForRow(for indexPath:IndexPath) -> FeedCellDataSource
    func getDataForSectionHeader(for section:Int) -> FeedSectionHeaderDataSource
}

protocol FeedViewDelegate: class {
    func expandBtnTapped(section:Int)
    func itemDidSelect(indexPath: IndexPath)
    func segmentStateChanged(state:SegmentState)
}

class FeedView: UIView {

    @IBOutlet weak var noResultsLbl: UILabel!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    @IBOutlet weak var segmentVw: UISegmentedControl!

    weak var dataSource:FeedViewDataSource?
    weak var delegate:FeedViewDelegate?
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        delegate?.segmentStateChanged(state: SegmentState(rawValue: sender.selectedSegmentIndex) ?? SegmentState.New)
    }
    
    func reloadData(){
        noResultsLbl.isHidden = (dataSource?.numberOfSections != 0)
        segmentVw.selectedSegmentIndex = dataSource?.segmentState.rawValue ?? 0
        feedCollectionView.reloadData()
    }
}

extension FeedView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(for: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FeedSectionCollectionReusableViewIdentifier", for: indexPath) as! FeedSectionCollectionReusableView
            headerView.section = indexPath.section
            headerView.delegate = self
            if let data = dataSource?.getDataForSectionHeader(for: indexPath.section){
                headerView.updateView(data: data)
            }
            
            return headerView
        default:
            assertionFailure("Invalid view type")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCellIdentifier", for: indexPath) as! FeedCollectionViewCell
        
        if let data = dataSource?.getDataForRow(for: indexPath){
            cell.updateTheView(data: data)
        }
        
        return cell
    }
    
}

extension FeedView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.itemDidSelect(indexPath: indexPath)
    }
}

extension FeedView: FeedSectionHeaderDelegate{
    func expandBtnTapped(section: Int) {
        delegate?.expandBtnTapped(section: section)
    }
}
