//
//  FeedListTableViewCell.swift
//  RSS-Reader
//
//  Created by Santhosh Nampally on 25/07/19.
//  Copyright © 2019 Santhosh Nampally. All rights reserved.
//

import UIKit

class FeedListTableHeaderView : UITableViewHeaderFooterView {
    static let reuseIdentifier = "FeedListTableHeaderViewIdentifier"
    static let height: CGFloat = 40
    
    var expandableBtn: UIButton = UIButton.init(type: UIButton.ButtonType.system)
    var section:Int = 0
    var delegate:FeedSectionHeaderDelegate?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        expandableBtn.frame =  CGRect(x: 0,y: 0,width: 0,height: 0)
        expandableBtn.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        expandableBtn.addTarget(self, action: #selector(expandButtonTapped(button:)), for: .touchDown)
        expandableBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        
        expandableBtn.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.9023972603)
        expandableBtn.layer.borderWidth = 1.0
        self.addSubview(expandableBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateView(data: FeedSectionHeaderDataSource) {
        expandableBtn.setTitle(data.title, for: UIControl.State.normal)
        expandableBtn.setImage(UIImage(named: data.imgName), for: UIControl.State.normal)
    }
    
    @objc func expandButtonTapped(button:UIButton) {
        delegate?.expandBtnTapped(section: section)
    }
}

class FeedListTableViewCell: UITableViewCell {

    static let reuseIdentifier = "FeedListTableViewCellIdentifier"
    @IBOutlet weak var titleLbl: UILabel!

    func updateTheView(data: FeedCellDataSource) {
        titleLbl.text = data.feedtitle
    }
}
