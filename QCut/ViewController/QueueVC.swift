//
//  QueueVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit

class QueueVC: UIViewController {
    
    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var street1: UILabel!
    @IBOutlet weak var street2: UILabel!
    @IBOutlet weak var locationUV: UIView!
    @IBOutlet weak var favoriteUV: UIView!
    @IBOutlet weak var scheduleTimeUV: UIView!
    @IBOutlet weak var scheduleTimeLB: UILabel!
    @IBOutlet weak var leaveUB: UIView!
    @IBOutlet weak var leaveLB: UILabel!
    
    @IBOutlet weak var unqueUV: UIView!
    
    @IBOutlet weak var dearLB: UILabel!
    @IBOutlet weak var waitingLB: UILabel!
    @IBOutlet weak var topUV: UIView!
    
    var barberShop: BarberShop = BarberShop()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    func initUIView(){
        scheduleTimeLB.textColor = UIColor.mainGreen()
//        scheduleTimeUV.roundCorners(corners: [.allCorners], radius: scheduleTimeUV.frame.height / 2)
        scheduleTimeUV.setShadowRadiusToUIView(radius: scheduleTimeUV.frame.height / 2)
        scheduleTimeUV.layer.borderColor = UIColor.mainGreen().cgColor
        scheduleTimeUV.layer.borderWidth = 2.0
        
        leaveUB.setShadowRadiusToUIView(radius: leaveUB.frame.height / 2)
        leaveUB.layer.borderColor = UIColor.systemBlue.cgColor
        leaveUB.layer.borderWidth = 1.0
        
        let tapLeaveUB = UITapGestureRecognizer(target: self, action: #selector(onTapLeaveUB))
        leaveUB.addGestureRecognizer(tapLeaveUB)
        
        topUV.setShadowRadiusToUIView()
        
        if Global.isQueued {
            print("queued")
            unqueUV.isHidden = true
            
            barberShop = Global.gBarberShop
            
            shopName.text = barberShop.shopName
            street1.text = barberShop.street1
            street2.text = barberShop.street2 + ", " + barberShop.city
            
        } else {
            print("Unqueued")
            unqueUV.isHidden = false
        }
    }
    
    @objc func onTapLeaveUB() {
        Global.isQueued = false
        self.tabBarController?.selectedIndex = 0
    }
}
