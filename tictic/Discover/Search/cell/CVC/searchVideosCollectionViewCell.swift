//
//  searchVideosCollectionViewCell.swift
//  TIK TIK
//
//  Created by Junaid  Kamoka on 07/11/2020.
//  Copyright © 2020 Junaid Kamoka. All rights reserved.
//

import UIKit
import SDWebImage

class searchVideosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var likeCountLbl: UILabel!
    
    @IBOutlet weak var heartImg: UIImageView!
    @IBOutlet weak var vidImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        guard userImg != nil else{return}
        userImg.layer.masksToBounds = false
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
    }
}
