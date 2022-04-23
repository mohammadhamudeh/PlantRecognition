//
//  PlantTableViewCell.swift
//  Plant Recognition
//
//  Created by Mohammad Hamudeh on 23/04/2022.
//

import UIKit

class PlantTableViewCell: UITableViewCell {

    @IBOutlet weak var cView: UIView!
    @IBOutlet weak var plantDecriptionLabel: UILabel!
    @IBOutlet weak var plantNAmeLAbel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var plantImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cView.layer.cornerRadius = 10
        cView.layer.shadowColor = UIColor.lightGray.cgColor
        cView.layer.shadowRadius = 2
        cView.layer.shadowOpacity = 2
        cView.layer.shadowOffset = .zero
        accuracyLabel.layer.cornerRadius = 5
        plantImage.layer.cornerRadius = cView.layer.cornerRadius
        plantImage.layer.maskedCorners =  [.layerMinXMinYCorner,.layerMinXMaxYCorner]
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
