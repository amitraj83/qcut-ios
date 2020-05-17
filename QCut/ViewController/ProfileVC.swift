//
//  ProfileVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import MaterialComponents
import FirebaseAuth

class ProfileVC: UIViewController {

    @IBOutlet weak var profileOutLet: UIView!
    @IBOutlet weak var avatarUIMG: UIImageView!
    @IBOutlet weak var cameraUIMG: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var nameEditUIMG: UIImageView!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var passwordEditUIMG: UIImageView!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var locationEditUIMG: UIImageView!
        
    @IBOutlet weak var logoutUIV: UIView!
    var location = String()
    var locations = ["Doublin 10","Dublin 11","Dublin 12","Dublin 13","Dublin 14","Dublin 15"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUIView()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func initUIView() {
        
        avatarUIMG.roundCorners(corners: [.allCorners], radius: avatarUIMG.frame.height / 2)
        
        let tapName = UITapGestureRecognizer(target: self, action: #selector(onTapNamePen))
        nameEditUIMG.addGestureRecognizer(tapName)
        nameEditUIMG.isHidden = true
        
        nameLB.text = Global.gUser.name
        emailLB.text = Global.gUser.email
        locationLB.text = Global.gUser.location
        
        let tapPassword = UITapGestureRecognizer(target: self, action: #selector(onTapPasswrodPen))
        passwordEditUIMG.addGestureRecognizer(tapPassword)
        passwordEditUIMG.isHidden = true
        
        let tapLocation = UITapGestureRecognizer(target: self, action: #selector(onTapLocationPen))
        locationEditUIMG.addGestureRecognizer(tapLocation)
        locationLB.text = Global.gUser.location
        
        let tapLogout = UITapGestureRecognizer(target: self, action: #selector(onTapLogout))
        logoutUIV.setShadowRadiusToUIView()
        logoutUIV.addGestureRecognizer(tapLogout)
        
        profileOutLet.setShadowRadiusToUIView()
    }
    
    @objc func onTapLogout() {
        try! Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
        
//        if let storyboard = self.storyboard {
//            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! UINavigationController
//            self.present(vc, animated: false, completion: nil)
//            }
    }
    
    @objc func onTapNamePen() {
        self.onShowEditVC(type: 0)
    }
    
    @objc func onTapPasswrodPen() {
        self.onShowEditVC(type: 1)
    }
    
    @objc func onTapLocationPen() {
        self.onShowEditVC(type: 2)
    }
    
    func onShowEditVC(type: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileEditVC") as! ProfileEditVC
        vc.modalPresentationStyle = .fullScreen
        vc.type = type
        self.present(vc, animated: true, completion: nil)
    }

}

