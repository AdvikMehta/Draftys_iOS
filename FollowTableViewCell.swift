//
//  FollowTableViewCell.swift
//  TIK TIK
//
//  Created by Junaid Kamoka on 30/06/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit

class FollowTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var follow_img: UIImageView!
    
    @IBOutlet weak var follow_view: UIView!
    
    @IBOutlet weak var folow_name: UILabel!
    
    @IBOutlet weak var folow_username: UILabel!
    
    @IBOutlet weak var btn_follow: UIButton!
    
    @IBOutlet weak var foolow_btn_view: UIView!
    
    @IBOutlet weak var btnWatch: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.btnWatch.backgroundColor = UIColor(red: 32 / 255.0, green: 40 / 255.0, blue: 51 / 255.0, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
