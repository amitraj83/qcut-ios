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
    
    init() {
        id = ""
        email = ""
        photo = ""
    }
    
    func toFirebaseData() -> [String: Any] {
        return [
            "id" : id,
            "email" : email,
            "photo" : photo,
        ]
    }
    
    func fromFirebase(data: [String: Any]) {
        id = data["id"] as! String
        email = data["email"] as! String
//        photo = data["photo"] as! String
    }
}
