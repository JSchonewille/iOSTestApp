//
//  TestScanCell.swift
//  iBeacons
//
//  Created by Leo van der Zee on 01-10-14.
//  Copyright (c) 2014 Move4Mobile. All rights reserved.
//

import UIKit

class TestScanCell: UITableViewCell {
    
    @IBOutlet var labelMajor: UILabel!
    @IBOutlet var labelMajorOutput: UILabel!
    @IBOutlet var labelProximity: UILabel!
    @IBOutlet var labelProximityOutput: UILabel!
    @IBOutlet var labelRSSI: UILabel!
    @IBOutlet var labelRSSIOutput: UILabel!
    @IBOutlet var labelMinor: UILabel!
    @IBOutlet var labelMinorOutput: UILabel!




    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
