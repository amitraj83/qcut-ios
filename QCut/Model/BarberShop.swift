//
//  BarberShop.swift
//  QCut
//
//  Created by Aira on 3/12/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation

class BarberShop {
    var id: String
    var street1: String
    var street2: String
    var gMapLink: String
    var shopName: String
    var city: String
    
    
    init() {
        id = ""
        street1 = ""
        street2 = ""
        gMapLink = ""
        shopName = ""
        city = ""
    }
    
    func fromFirebase(data: [String: Any]) {
        id = data["key"] as! String
        street1 = data["addressLine1"] as! String
        street2 = data["addressLine2"] as! String
        gMapLink = data["gmapLink"] as! String
        shopName = data["shopName"] as! String
        city = data["city"] as! String
    }
}
