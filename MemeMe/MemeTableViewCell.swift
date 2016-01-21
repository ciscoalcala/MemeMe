//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by francisco Alcala on 1/17/16.
//  Copyright © 2016 ciscoalcala. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeImageTopLabel: UILabel!
    @IBOutlet weak var memeImageBottomLabel: UILabel!
    
    @IBOutlet weak var memeCellTopLabel: UILabel!
    @IBOutlet weak var memeCellBottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
