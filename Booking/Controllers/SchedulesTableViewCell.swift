//
//  SchedulesTableViewCell.swift
//  Booking
//
//  Created by Max Mendes on 10/10/20.
//

import UIKit

class SchedulesTableViewCell: UITableViewCell {

    @IBOutlet weak var courtLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
