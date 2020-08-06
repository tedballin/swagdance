//
//  MyCell.swift
//  dance
//
//  Created by tedChiu on 2020/7/23.
//  Copyright © 2020 tedChiu. All rights reserved.
//

import UIKit
class MyCell: UITableViewCell {
    
    @IBOutlet weak var imgDance: UIImageView!
    @IBOutlet weak var lblDanceName: UILabel!
    
    @IBOutlet weak var buzy: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.systemFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
