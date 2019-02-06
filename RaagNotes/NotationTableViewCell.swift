//
//  NotationTableViewCell.swift
//  RaagNotes
//
//  Created by Irvanjit Singh on 2019-02-05.
//  Copyright © 2019 Irvanjit Singh. All rights reserved.
//

import UIKit

class NotationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
