//
//  BarbershopCell.swift
//  QCut
//
//  Created by Aira on 3/12/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit

class BarbershopCell: UITableViewCell {

    @IBOutlet weak var street1UL: UILabel!
    @IBOutlet weak var street2UL: UILabel!
    @IBOutlet weak var bgUIMG: UIImageView!
    @IBOutlet weak var locationUV: UIView!
    @IBOutlet weak var queueUV: UIView!
    @IBOutlet weak var favouriteUV: UIView!
    @IBOutlet weak var favouriteUL: UILabel!
    @IBOutlet weak var queueUL: UILabel!
    @IBOutlet weak var distabceUL: UILabel!
    @IBOutlet weak var containerUV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationUV.layer.cornerRadius = 5.0
        locationUV.layer.borderColor = UIColor(named: "colorMainBorder")?.cgColor
        locationUV.layer.borderWidth = 1.0
        
        queueUV.layer.cornerRadius = 5.0
        queueUV.layer.borderColor = UIColor(named: "colorMainBorder")?.cgColor
        queueUV.layer.borderWidth = 1.0
        
        favouriteUV.layer.cornerRadius = 5.0
        favouriteUV.layer.borderColor = UIColor(named: "colorMainBorder")?.cgColor
        favouriteUV.layer.borderWidth = 1.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
