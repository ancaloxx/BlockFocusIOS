//
//  BubbleCell.swift
//  BlockFocusApp
//
//  Created by ancalox on 05/09/25.
//

import UIKit

class BubbleCell: UITableViewCell {

    @IBOutlet weak var mainView: CustomView!
    @IBOutlet weak var bubbleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
