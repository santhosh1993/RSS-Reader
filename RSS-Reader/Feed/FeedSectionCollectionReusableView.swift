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
    @IBOutlet weak var expandableImg: UIImageView!
    
    func updateView(data: FeedSectionHeaderDataSource) {
        titleLbl.text = data.title
        expandableImg.image = UIImage(named: data.imgName)
    }
}
