//
//  AccelerometerCell.swift
//  TemplateProject
//
//  Created by Benoit PASQUIER on 13/01/2018.
//  Copyright © 2018 Benoit PASQUIER. All rights reserved.
//

import UIKit

class PlanetCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rotationLabel: UILabel!
    @IBOutlet weak var orbitLabel: UILabel!
    @IBOutlet weak var diameterLabel: UILabel!
    
    var planet: Planet? {
        didSet {
            guard let planet = planet else { return }
            titleLabel.text = planet.name
            rotationLabel.text = planet.rotationPeriod
            orbitLabel.text = planet.orbitalPeriod
            diameterLabel.text = planet.diameter.formatNumberString()
        }
    }
}
