//
//  RaagTableViewCell.swift
//  RaagNotes

import UIKit

class RaagTableViewCell: UITableViewCell {
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellThaatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
