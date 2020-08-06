//
//  LoveCell.swift
//  dance
//
//  Created by tedChiu on 2020/7/28.
//  Copyright © 2020 tedChiu. All rights reserved.
//

import UIKit

class LoveCell: UITableViewCell {

    @IBOutlet weak var imgPicture: UIImageView!
    
    @IBOutlet weak var lblDance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
