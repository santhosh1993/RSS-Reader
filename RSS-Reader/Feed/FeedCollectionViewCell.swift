//
//  FeedCollectionViewCell.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 11/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    func updateTheView(data: FeedCellDataSource) {
        titleLbl.text = data.feedtitle
    }
}
