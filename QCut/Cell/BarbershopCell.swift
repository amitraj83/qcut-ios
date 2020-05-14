//
//  BarbershopCell.swift
//  QCut
//
//  Created by Aira on 3/12/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import CoreLocation

class BarbershopCell: UITableViewCell {

    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var street1UL: UILabel!
    @IBOutlet weak var street2UL: UILabel!
    
    @IBOutlet weak var locationUV: UIView!
    @IBOutlet weak var favouriteUV: UIView!
    @IBOutlet weak var favouriteUL: UILabel!
    @IBOutlet weak var distabceUL: UILabel!
    @IBOutlet weak var containerUV: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favouriteUV.layer.cornerRadius = 16.0
        favouriteUV.layer.borderColor = UIColor.systemYellow.cgColor
        favouriteUV.layer.borderWidth = 2.0
        
        contentView.setShadowRadiusToUIView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWithData(barber: BarberShop, myLocation: CLLocation) {
        
        shopName.text = barber.shopName
        street1UL.text = barber.street1
        street2UL.text = barber.street2 + ", " + barber.city
        let maplink = barber.gMapLink
        let lat = maplink.components(separatedBy: ",")[0]
        let lon = maplink.components(separatedBy: ",")[1]
        
//        let myLocation = CLLocation(latitude: 53.393532, longitude: -6.385874)
        let barberLocation = CLLocation(latitude: Double(lat) as! CLLocationDegrees, longitude: Double(lon)!)
        let distance = myLocation.distance(from: barberLocation)
        let strDistance = String(format: "%.1f", distance / 1000)
        distabceUL.text = strDistance + "Km"
    }
    
}
