//
//  itemTableViewCell.swift
//  Thela At Home
//
//  Created by Vandit Jain on 12/04/20.
//  Copyright © 2020 jainvandit. All rights reserved.
//

import UIKit
import GMStepper

class itemTableViewCell: UITableViewCell {

    
    let nameLabel = UILabel()
    let itemImage = UIImageView()
    let priceLabel = UILabel()
    let stepper = GMStepper()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stepper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stepper)
        
        stepper.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        stepper.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        stepper.widthAnchor.constraint(equalToConstant: 70).isActive = true
        stepper.heightAnchor.constraint(equalToConstant: 25).isActive = true
        stepper.buttonsBackgroundColor = Colors.green
        stepper.buttonsTextColor = .white
        stepper.labelTextColor = Colors.green
        stepper.labelBackgroundColor = Colors.secondaryLight
        stepper.labelFont = UIFont(name: "AvenirNext-Regular", size: 16)!
        stepper.maximumValue = 10
        
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(itemImage)
        itemImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        itemImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 16 ).isActive = true
        itemImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16 ).isActive = true
        itemImage.widthAnchor.constraint(equalToConstant: 75 - 32).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "AvenirNext-Regular", size: 16)!
        nameLabel.leftAnchor.constraint(equalTo: itemImage.rightAnchor, constant: 16).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8).isActive = true
        nameLabel.textColor = Colors.secondaryDark
        itemImage.image = UIImage(named: "cart")
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(priceLabel)
        priceLabel.font = UIFont(name: "AvenirNext-Regular", size: 14)!
        priceLabel.leftAnchor.constraint(equalTo: itemImage.rightAnchor, constant: 16).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 12).isActive = true
        priceLabel.textColor = Colors.darkGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
