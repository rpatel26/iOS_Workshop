//
//  AlarmCell.swift
//  AlarmClock
//
//  Created by Ravi Patel on 4/13/19.
//  Copyright © 2019 iOS_Tutorial. All rights reserved.
//

import UIKit

class AlarmCell: UITableViewCell {

    @IBOutlet weak var alarm_title: UILabel!
    @IBOutlet weak var alarm_time: UILabel!
    @IBOutlet weak var alarm_switch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
