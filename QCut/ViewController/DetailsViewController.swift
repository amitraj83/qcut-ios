//
//  DetailsViewController.swift
//  QCut
//
//  Created by JinYC on 3/12/20.
//  Copyright © 2020 JinYC. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var queueUV: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initUIView()
    }
    
    func initUIView() {
        queueUV.layer.cornerRadius = 20.0
        queueUV.layer.borderWidth = 2.0
        queueUV.layer.borderColor = UIColor(named: "colorMainGreen")?.cgColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapJoin))
        queueUV.addGestureRecognizer(gesture)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func onTapJoin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SelectBarberVC") as! SelectBarberVC
        vc.providesPresentationContextTransitionStyle = true
        vc.definesPresentationContext = true
        vc.selectBarberDelegate = self
        self.present(vc, animated: true, completion: nil)
    }

}

extension DetailsViewController: SelectBarberDelegate {
    func dismissDelegate() {
        print("dismiss")
        Global.isQueued = true
        self.tabBarController?.selectedIndex = 1
        
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
}
