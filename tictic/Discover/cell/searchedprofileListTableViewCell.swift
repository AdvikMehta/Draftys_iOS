//
//  searchedprofileListTableViewCell.swift
//  Draftys
//
//  Created by Aniruddha on 23/07/21.
//  Copyright © 2021 Junaid Kamoka. All rights reserved.
//

import UIKit

class searchedprofileListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var profileHolderView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var profileUserNameLbl: UILabel!
    @IBOutlet weak var profileNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.profileHolderView.layer.shadowColor = UIColor.gray.cgColor
//            self.profileHolderView.layer.shadowOffset = CGSize(width: 1.0, height: 3.0)
//        self.profileHolderView.layer.shadowOpacity = 0.25
//        self.profileHolderView.layer.shadowRadius = 3.0
//        self.profileHolderView.layer.masksToBounds = false
//        self.profileHolderView.layer.cornerRadius = 8.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
