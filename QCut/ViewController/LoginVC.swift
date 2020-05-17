//
//  ViewController.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import MaterialComponents
import Toast_Swift
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var loginAreaUIV: UIView!
    @IBOutlet weak var mdcEmailTF: MDCTextField!
    @IBOutlet weak var mdcPasswordTF: MDCTextField!
    @IBOutlet weak var signUB: UIButton!
    @IBOutlet weak var facebookUB: UIButton!
    @IBOutlet weak var googleUB: UIButton!
    
    @IBOutlet weak var signInButnUIV: UIView!
    var emailMDCController: MDCTextInputControllerOutlined?
    var passwordMDCController: MDCTextInputControllerOutlined?
    
    var emailIcon: UIButton!
    var passwordToggleUB: UIButton!
    
    var isShowPassword = false
    
    let loginManager:LoginManager = LoginManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initUIView()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    func initUIView() {
        
        loginAreaUIV.setShadowRadiusToUIView()
        signInButnUIV.setShadowRadiusToUIView()
        
        emailMDCController = MDCTextInputControllerOutlined(textInput: mdcEmailTF)
        emailMDCController?.setMDCTextInputOutline()
        
        passwordMDCController = MDCTextInputControllerOutlined(textInput: mdcPasswordTF)
        passwordMDCController?.setMDCTextInputOutline()
        
        mdcEmailTF.clearButton.isHidden = true
        mdcPasswordTF.clearButton.isHidden = true
        
        emailIcon = UIButton(type: .custom)
        emailIcon.setImage(UIImage.icEmail(), for: .normal)
        emailIcon.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        emailIcon.frame = CGRect(x: CGFloat(mdcEmailTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        mdcEmailTF.rightView = emailIcon
        mdcEmailTF.rightViewMode = .always
        
        passwordToggleUB = UIButton(type: .custom)
        passwordToggleUB.setImage(UIImage.icLock(), for: .normal)
        passwordToggleUB.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        passwordToggleUB.frame = CGRect(x: CGFloat(mdcPasswordTF.frame.size.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(25))
        passwordToggleUB.addTarget(self, action: #selector(self.refresh), for: .touchUpInside)
        mdcPasswordTF.rightView = passwordToggleUB
        mdcPasswordTF.rightViewMode = .always
        
        facebookUB.setShadowRadiusToUIView(radius: 10.0)
        
        googleUB.setShadowRadiusToUIView(radius: 10.0)
    }
    
    @IBAction func goToSignIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func refresh() {
        if !isShowPassword {
            passwordToggleUB.setImage(UIImage.icUnlock(), for: .normal)
            mdcPasswordTF.isSecureTextEntry = false
        } else {
            passwordToggleUB.setImage(UIImage.icLock(), for: .normal)
            mdcPasswordTF.isSecureTextEntry = true
        }
        isShowPassword = !isShowPassword
    }
    
    @IBAction func onTapLoginUB(_ sender: Any) {
        if !mdcEmailTF.emailValidation() {
            self.view.makeToast("Email not match.")
        } else if !mdcPasswordTF.passwordValidation() {
            self.view.makeToast("Password must be over 6 digits.")
        } else {
            Global.onShowProgressView(name: "Connecting")
            
            Auth.auth().signIn(withEmail: self.mdcEmailTF.text!, password: self.mdcPasswordTF.text!, completion: {(usr, err) in
                if err != nil {
                    Global.onhideProgressView()
                    self.view.makeToast("Account does not exist.")
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
        }
    }
    
    @IBAction func onTapFacebookUB(_ sender: Any) {
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                    }
                    
                }
            }
        }
    }
    
    @IBAction func onTapGoogleUB(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func getFBUserData(){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result as Any)
                    guard let accessToken = AccessToken.current else {
                        print("Failed to get access token")
                        return
                    }
                    let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                    Global.onShowProgressView(name: "Loading...")
                    Auth.auth().signIn(with: credential, completion: {(user, error) in
                        if error != nil {
                            self.view.makeToast("Error has been occured.")
                            Global.onhideProgressView()
                        } else {
                            Database.database().reference().child("Customers").observe(.value, with: {snapshot in
                                if snapshot.hasChild((user?.user.uid)!){
                                    self.getFBUserInfo(userId: (user?.user.uid)!)
                                } else {
                                    self.saveFBUSERInfo(result: result as! [String: Any], userID: (user?.user.uid)!)
                                }
                            })
                            Global.onhideProgressView()
                            UserDefaults.standard.set("Facebook", forKey: "loginType")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    })
                }
                else {
                    print(error?.localizedDescription as Any)
                    
                }
            })
        }
    }
    
    func getFBUserInfo(userId: String) {
        Database.database().reference().child("Customers").child(userId).observe(.value, with: {snapshot in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            Global.gUser.fromFirebase(data: postDict)
        })
    }
    
    func saveFBUSERInfo(result: [String: Any], userID: String) {
        Global.gUser.id = userID
        Global.gUser.email = result["email"] as! String
        
        if let picture = result["picture"] as? [String:Any] , let imgData = picture["data"] as? [String:Any] , let imgUrl = imgData["url"] as? String {
            Global.gUser.photo = imgUrl
        }
        Database.database().reference().child("Customers").child(userID).setValue(Global.gUser.toFirebaseData())
    }
}

extension LoginVC: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        Global.onShowProgressView(name: "Connecting")
        if error != nil {
            Global.onhideProgressView()
            print(error.localizedDescription)
        } else {
            guard let authentication = user.authentication else {return}
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential, completion: {(authResult, err) in
                if let err = err {
                    Global.onhideProgressView()
                    print(err.localizedDescription)
                    return
                }
                Global.onhideProgressView()
                
                Global.gUser.id = (authResult?.user.uid)!
                Global.gUser.email = user.profile.email
                if user.profile.hasImage {
                    Global.gUser.photo = (user.profile.imageURL(withDimension: 200))!.absoluteString
                } else {
                    Global.gUser.photo = ""
                }
                var ref: DatabaseReference!
                ref = Database.database().reference()
                ref.child("Customers").child(Global.gUser.id).setValue(Global.gUser.toFirebaseData())
                UserDefaults.standard.set("Google", forKey: "loginType")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "TabVC") as! TabVC
                self.navigationController?.pushViewController(vc, animated: true)
            })
        }
    }
}

