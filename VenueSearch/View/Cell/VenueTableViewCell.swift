//
//  VenueTableViewCell.swift
//  VenueSearch
//
//  Created by Grzegorz Sowa on 26/05/2019.
//  Copyright © 2019 Sowa. All rights reserved.
//

import UIKit

class VenueTableViewCell: UITableViewCell {

    static var identifier = String(describing: VenueTableViewCell.self)
    
    //Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
}
