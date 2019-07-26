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
    var feedDescription:String? {get}
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
    func deleteActionOccurred(indexPath: IndexPath)
}

class FeedView: UIView {

    @IBOutlet weak var noResultsLbl: UILabel!
    @IBOutlet weak var segmentVw: UISegmentedControl!
    @IBOutlet weak var feedListTableView: UITableView!
    
    weak var dataSource:FeedViewDataSource?
    weak var delegate:FeedViewDelegate?
    
    override func awakeFromNib() {
        feedListTableView.register(FeedListTableHeaderView.self, forHeaderFooterViewReuseIdentifier: FeedListTableHeaderView.reuseIdentifier)
    }
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        delegate?.segmentStateChanged(state: SegmentState(rawValue: sender.selectedSegmentIndex) ?? SegmentState.New)
    }
    
    func reloadData(){
        noResultsLbl.isHidden = (dataSource?.numberOfSections != 0)
        segmentVw.selectedSegmentIndex = dataSource?.segmentState.rawValue ?? 0
        feedListTableView.reloadData()
    }
}

extension FeedView: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows(for: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FeedListTableHeaderView.height
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction.init(style: UITableViewRowAction.Style.destructive, title: "Delete") { (action, indexPath) in
            self.delegate?.deleteActionOccurred(indexPath: indexPath)
        }
        return [action]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedListTableHeaderView.reuseIdentifier) as! FeedListTableHeaderView
        headerView.section = section
        headerView.delegate = self
        
        if let data = dataSource?.getDataForSectionHeader(for: section){
            headerView.updateView(data: data)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedListTableViewCell.reuseIdentifier, for: indexPath) as! FeedListTableViewCell
        
        if let data = dataSource?.getDataForRow(for: indexPath){
            cell.updateTheView(data: data)
        }
        
        return cell
    }
}

extension FeedView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.itemDidSelect(indexPath: indexPath)
    }
}

extension FeedView: FeedSectionHeaderDelegate{
    func expandBtnTapped(section: Int) {
        delegate?.expandBtnTapped(section: section)
    }
}
