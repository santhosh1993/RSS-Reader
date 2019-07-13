//
//  FeedSectionCollectionReusableView.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 11/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class FeedSectionCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var expandableBtn: UIButton!
    var section:Int = 0
    var delegate:FeedSectionHeaderDelegate?
    
    func updateView(data: FeedSectionHeaderDataSource) {
        titleLbl.text = data.title
        expandableBtn.setImage(UIImage(named: data.imgName), for: UIControl.State.normal)
    }
    
    @IBAction func expandBtnTapped(_ sender: Any) {
        delegate?.expandBtnTapped(section: section)
    }
}
