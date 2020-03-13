//
//  SearchVC.swift
//  QCut
//
//  Created by Aira on 3/11/20.
//  Copyright © 2020 Aira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation

class SearchVC: UIViewController {

    @IBOutlet weak var barberShopTV: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var barberShopArr = [BarberShop]()
    let locationManager = CLLocationManager()
    
    var lat = 0.0
    var lon = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        initData()
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
    
    func initData() {
        Global.onShowProgressView(name: "Loading")
        Database.database().reference().child("shopDetails").observe(.value, with: {snap in
            self.barberShopArr.removeAll()
            for child in snap.children {
                Global.onhideProgressView()
                let snapChild = child as! DataSnapshot
                let barberShop = BarberShop()
                let postDict = snapChild.value as? [String: Any] ?? [:]
                barberShop.fromFirebase(data: postDict)
                self.barberShopArr.append(barberShop)
            }
            self.barberShopTV.reloadData()
        })
        
//        for i in 0...5 {
//            let barberShopItem = BarberShop()
//            barberShopItem.id = "123456789"
//            barberShopItem.street1 = "Dublin 15"
//            barberShopItem.street2 = "Unit 2, Coolmine, Dublin 15"
//            barberShopArr.append(barberShopItem)
//        }
        
    }
    
    func initUIView() {
        barberShopTV.register(UINib(nibName: "BarbershopCell", bundle: nil), forCellReuseIdentifier: "BarbershopCell")
        barberShopTV.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        barberShopTV.rowHeight = UITableView.automaticDimension
        barberShopTV.dataSource = self
        barberShopTV.delegate = self
    }

}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return barberShopArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BarbershopCell", for: indexPath) as! BarbershopCell
        cell.street1UL.text = barberShopArr[indexPath.row].street1
        cell.street2UL.text = barberShopArr[indexPath.row].street2
        let maplink = barberShopArr[indexPath.row].gMapLink
        let lat = maplink.components(separatedBy: ",")[0]
        let lon = maplink.components(separatedBy: ",")[1]
        
        let myLocation = CLLocation(latitude: self.lat, longitude: self.lon)
//        let myLocation = CLLocation(latitude: 53.393532, longitude: -6.385874)
        let barberLocation = CLLocation(latitude: Double(lat) as! CLLocationDegrees, longitude: Double(lon) as! CLLocationDegrees)
        let distance = myLocation.distance(from: barberLocation)
        let strDistance = String(format: "%.1f", distance / 1000)
        cell.distabceUL.text = strDistance + "Km"
        print("\(distance)")
        return cell
    }
    
    
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.lat = locValue.latitude
        self.lon = locValue.longitude
    }
}
