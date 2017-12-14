//
//  BeaconTableViewCell.swift
//  SampleApp
//
//  Created by Sachin Vas on 11/12/17.
//  Copyright © 2017 MobStac. All rights reserved.
//

import UIKit

class BeaconTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var minor: UILabel!
    @IBOutlet weak var major: UILabel!
    @IBOutlet weak var uuid: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
