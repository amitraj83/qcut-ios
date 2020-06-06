//
//  DetailsViewController.swift
//  QCut
//
//  Created by JinYC on 3/12/20.
//  Copyright © 2020 JinYC. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var queueUV: UIView!
    @IBOutlet weak var emailLB: UILabel!
    @IBOutlet weak var offlineUB: UIButton!
    @IBOutlet weak var mapUV: MKMapView!
    
    var barberShop: BarberShop = BarberShop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let annotation = MKPointAnnotation()
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        
        //There should be a if check to make sure that gmaplink has value in the desired
        //also we need to make sure that gmapLink has a comma ","
        if barberShop.gMapLink.count > 0 && barberShop.gMapLink.contains(","){
            mapUV.isHidden = false
            let lat = barberShop.gMapLink.components(separatedBy: ",")[0]
            let lon = barberShop.gMapLink.components(separatedBy: ",")[1]
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!), span: span)
            mapUV.setRegion(region, animated: true)
            annotation.title = barberShop.shopName
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat)!, longitude: Double(lon)!)
            mapUV.addAnnotation(annotation)
            mapUV.delegate = self
        } else {
            //here if no comma
            mapUV.isHidden = true
        }
        
        // Do any additional setup after loading the view.
        initUIView()
    }
    
    func initUIView() {
        emailLB.text = "Email : " + barberShop.email
        
        queueUV.setShadowRadiusToUIView(radius: 20.0)
        offlineUB.setShadowRadiusToUIView()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapJoin))
        queueUV.addGestureRecognizer(gesture)
        
        if barberShop.status == "ONLINE" {
            queueUV.isHidden = false
            offlineUB.isHidden = true
        } else {
            queueUV.isHidden = true
            offlineUB.isHidden = false
        }
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
        if !UserDefaultManager.getBoolData(key: UserDefaultManager.IS_LOGGEDIN) {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let navigationController = UINavigationController(rootViewController: newViewController)
            navigationController.navigationBar.isHidden = true
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = navigationController
        } else {
            let pushManager = PushNotificationManager(userID: UIDevice.current.identifierForVendor!.uuidString)
            
            pushManager.registerForPushNotifications()
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyy"
            let curDate = formatter.string(from: date)
            
            Global.waitingTime = 0
            
            Global.onShowProgressView(name: "Loading")
            let childPath = Global.BARBER_WAITING_QUEUES + "/" + barberShop.id + "_" + curDate
            Database.database().reference().child(childPath).observeSingleEvent(of: .value, with: {snap in
                if(snap.exists()){
                    var desiredBarberKey: String = ""
                    var latestArrivalTimeLong: CLong = 0
                    var placeInQueue: Int = 0
                    
                    for barbers in snap.children {
                        let aBarber = barbers as! DataSnapshot
                        for customers in aBarber.children {
                            let customer: DataSnapshot = customers as! DataSnapshot
                            desiredBarberKey = aBarber.key
                            let customerSnap = customer.value as! [String: AnyObject]
                            let status = customerSnap["status"] as! String
                            
                            if (status == Global.Suit.queue.rawValue) {
                                placeInQueue +=  1;
                                let arrivalTime = customerSnap["arrivalTime"] as! CLong
                                let arrivalTimeLong = CLong(arrivalTime)
                                if (latestArrivalTimeLong < arrivalTimeLong) {
                                    latestArrivalTimeLong = arrivalTimeLong
                                    Global.waitingTime = customerSnap["expectedWaitingTime"] as! CLong
                                }
                            }
                        }
                    }
                    Global.onhideProgressView()
                    placeInQueue += 1
                    Global.waitingTime = Global.waitingTime + 15
                    self.pushCustomerToQueue(shopKey: self.barberShop.id, desiredBarberKey: desiredBarberKey, maxWaitingTime: Global.waitingTime, placeInQueue: placeInQueue)
                    
                    Global.isQueued = true
                    Global.gBarberShop = self.barberShop
                    self.tabBarController?.selectedIndex = 1
                    self.navigationController?.popToRootViewController(animated: false)
                } else {
                    Global.onhideProgressView()
                    Database.database().reference().child(Global.BARBERS).child(self.barberShop.id).queryOrdered(byChild: "queueStatus").queryEqual(toValue: "OPEN")
                        .observeSingleEvent(of: .value, with: {snap in
                            Global.onhideProgressView()
                            for child in snap.children {
                                let barber = child as! DataSnapshot
                                let desiredBarberKey = barber.key
                                self.pushCustomerToQueue(shopKey: self.barberShop.id, desiredBarberKey: desiredBarberKey, maxWaitingTime: 0, placeInQueue: 1)
                            }
                            Global.isQueued = true
                            Global.gBarberShop = self.barberShop
                            self.tabBarController?.selectedIndex = 1
                            self.navigationController?.popToRootViewController(animated: false)
                        })
                   }
            })
        }
        
    }
    
    func pushCustomerToQueue(shopKey: String, desiredBarberKey: String, maxWaitingTime: CLong , placeInQueue: Int) {
        let customerKey = Global.gUser.id
        
        let timestamp = Date().timeIntervalSince1970 * 1000
        let curtimeLong = CLong(String(format: "%.0f", timestamp))
        let queue: String = Global.Suit.queue.rawValue
        
        let customerToQueue = [
            "absent": false,
            "actualBarberId": desiredBarberKey,
            "actualProcessingTime": 0,
            "anyBarber": true,
            "addedBy": customerKey,
            "arrivalTime": curtimeLong!,
            "departureTime": 0,
            "dragAdjustedTime": 0,
            "expectedWaitingTime": maxWaitingTime,
            "key": customerKey,
            "channel": "CUSTOMER_APP",
            "lastPositionChangedTime": 0,
            "placeInQueue": placeInQueue,
            "serviceStartTime": 0,
            "serviceTime": 0,
            "status": queue,
            "timeAdded": -1,
            "customerId": Global.gUser.id,
            "name": Global.gUser.name
            ] as [String : Any]
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        let curDate = formatter.string(from: date)
        let childPath = Global.BARBER_WAITING_QUEUES + "/" + shopKey + "_" + curDate
        Database.database().reference().child(childPath).child(desiredBarberKey).child(customerKey).setValue(customerToQueue)
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

extension DetailsViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }
}
