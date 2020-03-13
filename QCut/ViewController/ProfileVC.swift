//
//  ProfileVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import MaterialComponents

class ProfileVC: UIViewController {

    @IBOutlet weak var icAvatar: UIImageView!
    @IBOutlet weak var icKey: UIImageView!
    @IBOutlet weak var icLocation: UIImageView!
    @IBOutlet weak var avatarUIMG: UIImageView!
    @IBOutlet weak var cameraUIMG: UIImageView!
    @IBOutlet weak var nameLB: UILabel!
    @IBOutlet weak var nameEditUIMG: UIImageView!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var passwordEditUIMG: UIImageView!
    @IBOutlet weak var locationLB: UILabel!
    @IBOutlet weak var locationEditUIMG: UIImageView!
        
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
        
        let tapPassword = UITapGestureRecognizer(target: self, action: #selector(onTapPasswrodPen))
        passwordEditUIMG.addGestureRecognizer(tapPassword)
        
        let tapLocation = UITapGestureRecognizer(target: self, action: #selector(onTapLocationPen))
        locationEditUIMG.addGestureRecognizer(tapLocation)
        
        icAvatar.setShadowRadiusToUIView(radius: icAvatar.frame.height / 2)
        icKey.setShadowRadiusToUIView(radius: icKey.frame.height / 2)
        icLocation.setShadowRadiusToUIView(radius: icLocation.frame.height / 2)
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

