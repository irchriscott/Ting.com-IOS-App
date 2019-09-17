//
//  HomeRestaurantsViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit

class HomeRestaurantsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    let headerId = "headerId"
    let cellId = "cellId"
    
    var spinnerViewHeight: CGFloat = 100
    var restaurants: [Branch] = []
    
    var locationManager = CLLocationManager()
    
    let mapFloatingButton: FloatingButton = {
        let view = FloatingButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_addess_white")
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.checkLocationAuthorization(status: CLLocationManager.authorizationStatus())
        
        collectionView.register(SpinnerViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.register(RestaurantViewCell.self, forCellWithReuseIdentifier: cellId)
        
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 50
        
        self.view.addSubview(mapFloatingButton)
        self.view.addConstraintsWithFormat(format: "H:[v0(50)]-12-|", views: mapFloatingButton)
        self.view.addConstraintsWithFormat(format: "V:[v0(50)]-\(tabBarHeight + 12)-|", views: mapFloatingButton)
    }
    
    private func getRestaurants(location: CLLocation?){
        APIDataProvider.instance.loadRestaurants(url: URLs.restaurantsGlobal) { (branches) in
            DispatchQueue.main.async {
                if !branches.isEmpty {
                    if let userLocation = location {
                        for var branch in branches {
                            let branchLocation = CLLocation(latitude: CLLocationDegrees(exactly: Double(branch.latitude)!)!, longitude: CLLocationDegrees(exactly: Double(branch.longitude)!)!)
                            branch.dist = Double(branchLocation.distance(from: userLocation) / 1000).rounded(toPlaces: 2)
                            if !self.restaurants.contains(where: { (b) -> Bool in
                                return b.id == branch.id
                            }){ self.restaurants.append(branch) }
                        }
                    } else { for var branch in self.restaurants { branch.dist = 0.00 } }
                }
                self.restaurants = self.restaurants.sorted(by: { $0.dist! < $1.dist! })
                self.spinnerViewHeight = 0
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.barTintColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = Colors.colorPrimaryDark
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .black
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "icon_unwind_25_white")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "icon_unwind_25_white")
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.title = ""
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .normal)
    }
    
    private func checkLocationAuthorization(status: CLAuthorizationStatus){
        self.locationManager.delegate = self
        switch status {
        case .authorizedAlways:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .denied:
            self.getRestaurants(location: nil)
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            break
        case .restricted:
            self.getRestaurants(location: nil)
            let alert = UIAlertController(title: "Please, Go to settings and allow this app to use your location", message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else { return }
        let location = CLLocation(latitude: CLLocationDegrees(0.3249535), longitude: CLLocationDegrees(32.56643859999997))
        self.getRestaurants(location: location)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RestaurantViewCell
        cell.branch = self.restaurants[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SpinnerViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.spinnerViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if !self.restaurants.isEmpty {
            
            let branch = self.restaurants[indexPath.item]
            let frameWidth = view.frame.width - CGFloat(118 + 18)
            
            let branchNameRect = NSString(string: "\(branch.name), \(branch.restaurant!.name)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: 16)!], context: nil)
            
            let branchAddressRect = NSString(string: "\(branch.name), \(branch.restaurant!.name)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
            
            let cellHeight: CGFloat = 2 + 20 + 4 + 8 + 45 + 8 + 26 + 8 + 26 + branchNameRect.height + branchAddressRect.height + 16
            
            return CGSize(width: view.frame.width, height: cellHeight)
        }
        return CGSize(width: view.frame.width, height: 210)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
    }
}

class SpinnerViewCell: UICollectionViewCell {
    
    let spinnerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.colorWhite
        return view
    }()
    
    let indicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    func setup(){
        spinnerView.frame = self.frame
        spinnerView.center = self.center
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center
        spinnerView.addSubview(indicatorView)
        addSubview(spinnerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
