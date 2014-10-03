//
//  ListBeaconCell.swift
//  iBeacons
//
//  Created by Leo van der Zee on 01-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit

class ListBeaconCell: UITableViewCell {

    @IBOutlet var labelNaam: UILabel!
    @IBOutlet var labelNaamOutput: UILabel!
    @IBOutlet var labelUuidOutput: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
