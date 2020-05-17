//
//  User.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import Foundation

class User {
    var id: String
    var email: String
    var photo: String
    var location: String
    
    var name: String
    var googleID: String
    var fbID: String
    var registeredInApp: Bool
    
    init() {
        id = ""
        email = ""
        photo = ""
        location = "n/a"
        name = ""
        googleID = ""
        fbID = ""
        registeredInApp = false
    }
    
    func toFirebaseData() -> [String: Any] {
        return [
            "id" : id,
            "email" : email,
            "photo" : photo,
            "city": location,
            "name": name,
            "googleID": googleID,
            "fbID": fbID,
            "registeredInApp": registeredInApp
        ]
    }
    
    func fromFirebase(data: [String: Any]) {
        id = data["id"] as! String
        email = data["email"] as! String
        location = data["city"] as! String
        name = data["name"] as! String
//        photo = data["photo"] as! String
    }
}
