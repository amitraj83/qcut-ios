//
//  SignUpVC.swift
//  QCut
//
//  Created by King on 2/29/1399 AP.
//  Copyright © 1399 Aira. All rights reserved.
//

import UIKit
import MaterialComponents
import FirebaseAuth
import FirebaseDatabase

class SignUpVC: UIViewController {

    @IBOutlet weak var signupAreaUIV: UIView!
    @IBOutlet weak var signUpBtnUIV: UIView!
    
    @IBOutlet weak var nameMDCTxt: MDCTextField!
    @IBOutlet weak var emailMDCTxt: MDCTextField!
    @IBOutlet weak var passwordMDCTxt: MDCTextField!
    
    var nameIcon: UIButton!
    var emailIcon: UIButton!
    var passwordToggleUB: UIButton!
    
    var nameMDCController: MDCTextInputControllerOutlined?
    var emailMDCController: MDCTextInputControllerOutlined?
    var passwordMDCController: MDCTextInputControllerOutlined?
    
    var isShowPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initUIView()
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        if nameMDCTxt.usernameEmptyCheck() {
            
        }else if !emailMDCTxt.emailValidation() {
            self.view.makeToast("Email not match.")
        } else if !passwordMDCTxt.passwordValidation() {
            self.view.makeToast("Password must be over 6 digits.")
        } else {
            Global.onShowProgressView(name: "Connecting")
            Auth.auth().createUser(withEmail: emailMDCTxt.text!, password: passwordMDCTxt.text!, completion: {(user, error) in
                if error != nil{
                    Auth.auth().signIn(withEmail: self.emailMDCTxt.text!, password: self.passwordMDCTxt.text!, completion: {(usr, err) in
                        if err != nil {
                            Global.onhideProgressView()
                            self.view.makeToast("Failed to register, please try again.")
                        } else {
                            Global.onhideProgressView()
                            Database.database().reference().child("Customers").child((usr?.user.uid)!).observe(.value, with: {snapshot in
                                let postDict = snapshot.value as? [String: AnyObject] ?? [:]
                                Global.gUser.fromFirebase(data: postDict)
                                UserDefaults.standard.set("Normal", forKey: "loginType")
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                                self.navigationController?.pushViewController(vc, animated: true)
                            })
                        }
                    })
                } else {
                    Global.onhideProgressView()
                    Global.gUser.id = (user?.user.uid)!
                    Global.gUser.name = self.nameMDCTxt.text!
                    Global.gUser.email = self.emailMDCTxt.text!
                    Global.gUser.photo = ""
                    
                    var ref: DatabaseReference!
                    ref = Database.database().reference()
                    ref.child("Customers").child(Global.gUser.id).setValue(Global.gUser.toFirebaseData())
                    UserDefaults.standard.set("Normal", forKey: "loginType")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
    }
    @IBAction func gotoSignIn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func initUIView(){
        signupAreaUIV.setShadowRadiusToUIView()
        signUpBtnUIV.setShadowRadiusToUIView()
        
        nameMDCController = MDCTextInputControllerOutlined(textInput: nameMDCTxt)
        nameMDCController?.setMDCTextInputOutline()
        
        emailMDCController = MDCTextInputControllerOutlined(textInput: emailMDCTxt)
        emailMDCController?.setMDCTextInputOutline()
        
        passwordMDCController = MDCTextInputControllerOutlined(textInput: passwordMDCTxt)
        passwordMDCController?.setMDCTextInputOutline()
        
//        nameMDCTxt.clearButton.isHidden = true
        emailMDCTxt.clearButton.isHidden = true
        passwordMDCTxt.clearButton.isHidden = true
        
        nameIcon = UIButton(type: .custom)
        nameIcon.setImage(UIImage.icAccount(), for: .normal)
        nameIcon.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        nameIcon.frame = CGRect(x: CGFloat(nameMDCTxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        nameMDCTxt.rightView = nameIcon
        nameMDCTxt.rightViewMode = .always
        
        emailIcon = UIButton(type: .custom)
        emailIcon.setImage(UIImage.icEmail(), for: .normal)
        emailIcon.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        emailIcon.frame = CGRect(x: CGFloat(emailMDCTxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        emailMDCTxt.rightView = emailIcon
        emailMDCTxt.rightViewMode = .always
        
        passwordToggleUB = UIButton(type: .custom)
        passwordToggleUB.setImage(UIImage.icLock(), for: .normal)
        passwordToggleUB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordToggleUB.frame = CGRect(x: CGFloat(passwordMDCTxt.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(25))
        passwordToggleUB.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        passwordMDCTxt.rightView = passwordToggleUB
        passwordMDCTxt.rightViewMode = .always
    }
    
    @objc func refresh() {
        if !isShowPassword {
            passwordToggleUB.setImage(UIImage.icUnlock(), for: .normal)
            passwordMDCTxt.isSecureTextEntry = false
        } else {
            passwordToggleUB.setImage(UIImage.icLock(), for: .normal)
            passwordMDCTxt.isSecureTextEntry = true
        }
        isShowPassword = !isShowPassword
    }
    
}
