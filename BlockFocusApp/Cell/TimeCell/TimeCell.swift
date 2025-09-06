//
//  TimeCell.swift
//  BlockFocusApp
//
//  Created by ancalox on 04/09/25.
//

import UIKit

class TimeCell: UITableViewCell {

    @IBOutlet weak var mainView: CustomView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
