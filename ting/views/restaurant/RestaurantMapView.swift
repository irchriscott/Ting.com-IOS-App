//
//  RestaurantMapView.swift
//  ting
//
//  Created by Christian Scott on 17/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class RestaurantMapView: UIView, GMSMapViewDelegate {
    
    var restaurantNameHeight: CGFloat = 25
    var restaurantAddressHeight: CGFloat = 16
    let device = UIDevice.type
    
    var restaurantNameTextSize: CGFloat = 16
    var restaurantAddressTextSize: CGFloat = 13
    var restaurantImageConstant: CGFloat = 80
    let numberFormatter = NumberFormatter()
    
    var googleMapsView: GMSMapView!
    
    let closeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        view.backgroundColor = UIColor(red: 0.56, green: 0.55, blue: 0.93, alpha: 0.5)
        return view
    }()
    
    let closeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.image = UIImage(named: "icon_close_bold_25_white")
        return view
    }()
    
    let restaurantView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorWhite
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let restaurantDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        view.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        view.alpha = 0.4
        view.image = UIImage(named: "default_restaurant")
        return view
    }()
    
    let restaurantProfileView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantName: UILabel = {
        let view = UILabel()
        view.font = UIFont(name: "Poppins-SemiBold", size: 16)
        view.textColor = Colors.colorGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Cafe Java, Kampala Road"
        view.numberOfLines = 2
        return view
    }()
    
    let restaurantRating: CosmosView = {
        let view = CosmosView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rating = 3
        view.settings.updateOnTouch = false
        view.settings.fillMode = .full
        view.settings.starSize = 17
        view.starMargin = 2
        view.totalStars = 5
        view.settings.filledColor = Colors.colorYellowRate
        view.settings.filledBorderColor = Colors.colorYellowRate
        view.settings.emptyColor = Colors.colorVeryLightGray
        view.settings.emptyBorderColor = Colors.colorVeryLightGray
        return view
    }()
    
    let iconAddressImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        view.image = UIImage(named: "icon_address_black")
        view.alpha = 0.5
        return view
    }()
    
    let restaurantAddress: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFont(name: "Poppins-Regular", size: 13)
        view.textColor = Colors.colorGray
        view.text = "Nana Hostel, Kampala, Uganda"
        view.numberOfLines = 2
        return view
    }()
    
    let restaurantAddressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantStatusView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantDistanceView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.iconAlpha = 0.4
        view.icon = UIImage(named: "icon_road_25_black")!
        view.text = "0.0 km"
        return view
    }()
    
    let restaurantTimeStatusView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.icon = UIImage(named: "icon_clock_25_white")!
        view.text = "Opening in 13 mins"
        view.textColor = Colors.colorWhite
        view.background = Colors.colorStatusTimeOrange
        return view
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.colorVeryLightGray
        return view
    }()
    
    let directionsText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Colors.colorGray
        view.font = UIFont(name: "Poppins-Medium", size: 15)
        view.text = "DIRECTIONS".uppercased()
        return view
    }()
    
    let directionsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let drivingDirectionView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Driving Mode"
        view.icon = UIImage(named: "icon_car_25_black")!
        view.iconAlpha = 0.4
        return view
    }()
    
    let walkingDirectionView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Walking Mode"
        view.icon = UIImage(named: "icon_walking_25_black")!
        view.iconAlpha = 0.4
        return view
    }()
    
    let directionDistanceText: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "-- min (-- km)"
        view.font = UIFont(name: "Poppins-SemiBold", size: 17)
        view.textColor = Colors.colorPrimaryDark
        return view
    }()
    
    open var controller: HomeRestaurantsViewController? {
        didSet { self.setupRestaurantView() }
    }
    
    open var cell: RestaurantViewCell? {
        didSet { self.setupRestaurantView() }
    }
    
    open var mapCenter: CLLocation? {
        didSet { self.setup() }
    }
    
    open var restaurants: [Branch] = [] {
        didSet { self.setup() }
    }
    
    open var restaurant: Branch? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let branch = self.restaurant {
                self.restaurantImageView.load(url: URL(string: "\(URLs.hostEndPoint)\(branch.restaurant!.logo)")!)
                self.restaurantImageView.alpha = 1.0
                self.restaurantName.text = "\(branch.restaurant!.name), \(branch.name)"
                self.restaurantRating.rating = Double(branch.reviews?.average ?? 0)
                self.restaurantAddress.text = branch.address
                self.restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: branch.dist ?? 0.00)) ?? "0.00") km"
                
                self.setTimeStatus()
                
                if UIDevice.smallDevices.contains(device) {
                    restaurantImageConstant = 55
                    restaurantNameTextSize = 14
                    restaurantAddressTextSize = 12
                } else if UIDevice.mediumDevices.contains(device) {
                    restaurantImageConstant = 70
                    restaurantNameTextSize = 15
                }
                
                let frameWidth = frame.width - (36 + restaurantImageConstant)
                
                let branchNameRect = NSString(string: "\(branch.name), \(branch.restaurant!.name)").boundingRect(with: CGSize(width: frameWidth, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-SemiBold", size: restaurantNameTextSize)!], context: nil)
                
                let branchAddressRect = NSString(string: branch.address).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)!], context: nil)
                
                restaurantAddressHeight = branchAddressRect.height
                restaurantNameHeight = branchNameRect.height
            }
            self.setupRestaurantView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Colors.colorWhite
        self.setup()
        self.drivingDirectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RestaurantMapView.onDrivingModeDirection)))
        self.walkingDirectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RestaurantMapView.onWalkingModeDirection)))
    }
    
    private func setup(){
        if let window = UIApplication.shared.keyWindow {
            let zoom: Float = self.mapCenter != nil ? 16 : 4
            let center = controller?.mapCenter != nil ? GMSCameraPosition.camera(withLatitude: controller?.mapCenter!.coordinate.latitude ?? 0.00, longitude: controller?.mapCenter!.coordinate.longitude ?? 0.00, zoom: zoom) : GMSCameraPosition.camera(withLatitude: mapCenter?.coordinate.latitude ?? 0.00, longitude: mapCenter?.coordinate.longitude ?? 0.00, zoom: zoom)
            self.googleMapsView = GMSMapView.map(withFrame: window.frame, camera: center)
            self.googleMapsView.delegate = self
            self.googleMapsView.camera = center
            self.googleMapsView.center = window.center
            self.googleMapsView.clear()
            
            self.addSubview(googleMapsView)
            
            if self.restaurants.count > 0 {
                for branch in self.restaurants {
                    let coords = CLLocation(latitude: CLLocationDegrees(Double(branch.latitude)!), longitude: CLLocationDegrees(Double(branch.longitude)!))
                    let markerView: CustomMapMarker = {
                        let view = CustomMapMarker()
                        view.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
                        return view
                    }()
                    
                    markerView.setup(path: "\(URLs.hostEndPoint)\(branch.restaurant!.logo)")
                    let marker = GMSMarker(position: coords.coordinate)
                    marker.iconView = markerView
                    
                    do {
                        let data = try JSONEncoder().encode(branch)
                        marker.snippet = String(data: data, encoding: .utf8)
                        marker.userData = branch
                    } catch {
                        marker.snippet = branch.address
                        marker.userData = branch
                    }
                    marker.tracksInfoWindowChanges = true
                    marker.map = self.googleMapsView
                }
            }
            
            self.closeButtonView.layer.cornerRadius = self.closeButtonView.frame.width / 2
            self.closeButtonView.layer.masksToBounds = true
            
            self.addSubview(closeButtonView)
            
            self.addConstraintsWithFormat(format: "V:|-12-[v0(30)]", views: closeButtonView)
            self.addConstraintsWithFormat(format: "H:|-12-[v0(30)]", views: closeButtonView)
            
            self.closeImageView.image = UIImage(named: "icon_close_bold_25_white")
            self.closeButtonView.addSubview(closeImageView)
            
            self.closeButtonView.addConstraintsWithFormat(format: "H:[v0(20)]", views: closeImageView)
            self.closeButtonView.addConstraintsWithFormat(format: "V:[v0(20)]", views: closeImageView)
            
            self.closeButtonView.addConstraint(NSLayoutConstraint(item: closeImageView, attribute: .centerX, relatedBy: .equal, toItem: closeButtonView, attribute: .centerX, multiplier: 1, constant: 0))
            self.closeButtonView.addConstraint(NSLayoutConstraint(item: closeImageView, attribute: .centerY, relatedBy: .equal, toItem: closeButtonView, attribute: .centerY, multiplier: 1, constant: 0))
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let branch = marker.userData as! Branch
        let view = RestaurantMapInfoWindowView()
        let frameWidth: CGFloat = 220
        let branchAddressRect = NSString(string: branch.address).boundingRect(with: CGSize(width: frameWidth - 18, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont(name: "Poppins-Regular", size: 13)!], context: nil)
        
        var valueToAdd: CGFloat = 0
        if branchAddressRect.height > 25 { valueToAdd += 8 }
        
        let restaurantDetailsFrameHeight: CGFloat = 16 * 3
        let frameHeightConstant: CGFloat = 12 + 30 + 4 + 17 + 12 + 1 + 12 + restaurantDetailsFrameHeight + 12 + 22
        let frameHeight: CGFloat = frameHeightConstant + frameWidth + branchAddressRect.height
        
        view.frame = CGRect(x: 0, y: 0, width: frameWidth + 16, height: frameHeight)
        view.branch = branch
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let branch = marker.userData as! Branch
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let restaurantViewController = storyboard.instantiateViewController(withIdentifier: "RestaurantView") as! RestaurantViewController
        restaurantViewController.restaurant = branch
        controller?.closeRestaurantMap()
        cell?.closeRestaurantMap()
        controller?.isMapOpened = true
        controller?.selectedBranch = branch
        controller?.mapCenter = CLLocation(latitude: CLLocationDegrees(Double(branch.latitude)!), longitude: CLLocationDegrees(Double(branch.longitude)!))
        controller?.navigationController?.pushViewController(restaurantViewController, animated: true)
    }
    
    private func setupRestaurantView(){
        self.setup()
        if let branch = self.restaurant {
            self.googleMapsView.clear()
            let coords = CLLocation(latitude: CLLocationDegrees(Double(branch.latitude)!), longitude: CLLocationDegrees(Double(branch.longitude)!))
            let markerView: CustomMapMarker = {
                let view = CustomMapMarker()
                view.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
                return view
            }()
            
            markerView.setup(path: "\(URLs.hostEndPoint)\(branch.restaurant!.logo)")
            let marker = GMSMarker(position: coords.coordinate)
            marker.iconView = markerView
            
            do {
                let data = try JSONEncoder().encode(branch)
                marker.snippet = String(data: data, encoding: .utf8)
                marker.userData = branch
            } catch {
                marker.snippet = branch.address
                marker.userData = branch
            }
            marker.tracksInfoWindowChanges = true
            marker.map = self.googleMapsView
            
            let restaurantDataViewHeight: CGFloat = restaurantNameHeight + 2 + 17 + 4 + restaurantAddressHeight + 4 + 26 + 8
            let viewHeight: CGFloat = 24 + restaurantDataViewHeight + 12 + 1 + 12 + 18 + 12 + 26 + 12 + 27 + 20
            
            directionsView.addSubview(drivingDirectionView)
            directionsView.addSubview(walkingDirectionView)
            
            directionsView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: drivingDirectionView, walkingDirectionView)
            directionsView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: drivingDirectionView)
            directionsView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: walkingDirectionView)
            
            restaurantView.addSubview(restaurantDataView)
            restaurantView.addSubview(separatorView)
            restaurantView.addSubview(directionsText)
            restaurantView.addSubview(directionsView)
            restaurantView.addSubview(directionDistanceText)
            
            restaurantView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: restaurantDataView)
            restaurantView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: separatorView)
            restaurantView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: directionsText)
            restaurantView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: directionsView)
            restaurantView.addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: directionDistanceText)
            restaurantView.addConstraintsWithFormat(format: "V:|-12-[v0(\(restaurantDataViewHeight))]-12-[v1(1)]-12-[v2(18)]-12-[v3(26)]-12-[v4(27)]", views: restaurantDataView, separatorView, directionsText, directionsView, directionDistanceText)
            
            restaurantAddressView.addSubview(iconAddressImageView)
            restaurantAddressView.addSubview(restaurantAddress)
            
            restaurantAddress.font = UIFont(name: "Poppins-Regular", size: restaurantAddressTextSize)
            
            restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantAddress)
            restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]", views: iconAddressImageView)
            restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantAddressHeight))]", views: restaurantAddress)
            
            
            restaurantStatusView.addSubview(restaurantDistanceView)
            restaurantStatusView.addSubview(restaurantTimeStatusView)
            
            let iconTextViewConstant: CGFloat = 37
            let restaurantDistanceViewWidth = iconTextViewConstant + restaurantDistanceView.textView.intrinsicContentSize.width
            let restaurantStatusTimeViewWidth = iconTextViewConstant + restaurantTimeStatusView.textView.intrinsicContentSize.width
            
            let _ = (37 * 2) + 8 + restaurantDistanceViewWidth + restaurantStatusTimeViewWidth
            
            restaurantStatusView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: restaurantDistanceView, restaurantTimeStatusView)
            restaurantStatusView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantDistanceView)
            restaurantStatusView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantTimeStatusView)
            
            restaurantProfileView.addSubview(restaurantName)
            restaurantProfileView.addSubview(restaurantRating)
            restaurantProfileView.addSubview(restaurantAddressView)
            restaurantProfileView.addSubview(restaurantStatusView)
            
            restaurantName.font = UIFont(name: "Poppins-SemiBold", size: restaurantNameTextSize)
            
            restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantName)
            restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantRating)
            restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantAddressView)
            restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantStatusView)
            restaurantProfileView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantNameHeight))]-2-[v1]-4-[v2(\(restaurantAddressHeight))]-8-[v3(26)]|", views: restaurantName, restaurantRating, restaurantAddressView, restaurantStatusView)
            
            restaurantDataView.addSubview(restaurantImageView)
            restaurantDataView.addSubview(restaurantProfileView)
            
            restaurantDataView.addConstraintsWithFormat(format: "V:|[v0(\(restaurantImageConstant))]", views: restaurantImageView)
            restaurantDataView.addConstraintsWithFormat(format: "V:|[v0]", views: restaurantProfileView)
            restaurantDataView.addConstraintsWithFormat(format: "H:|[v0(\(restaurantImageConstant))]-12-[v1]|", views: restaurantImageView, restaurantProfileView)
            
            addSubview(restaurantView)
            addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantView)
            addConstraintsWithFormat(format: "V:[v0(\(viewHeight))]|", views: restaurantView)
            
            if branch.isAvailable { Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(setTimeStatus), userInfo: nil, repeats: true) }
        }
    }
    
    @objc private func setTimeStatus(){
        if let branch = self.restaurant {
            if branch.isAvailable {
                let timeStatus = Functions.statusWorkTime(open: branch.restaurant!.opening, close: branch.restaurant!.closing)
                if let status = timeStatus {
                    self.restaurantTimeStatusView.text = status["msg"]!
                    switch status["clr"] {
                    case "orange":
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeOrange
                    case "red":
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeRed
                    case "green":
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeGreen
                    default:
                        self.restaurantTimeStatusView.background = Colors.colorStatusTimeOrange
                    }
                }
            } else {
                self.restaurantTimeStatusView.background = Colors.colorStatusTimeRed
                self.restaurantTimeStatusView.text = "Not Available"
                self.restaurantTimeStatusView.icon = UIImage(named: "icon_close_bold_25_white")!
            }
        }
    }
    
    @objc private func onDrivingModeDirection(){
        self.drivingDirectionView.background = Colors.colorDarkTransparent
        self.walkingDirectionView.background = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 0.7)
    }
    
    @objc private func onWalkingModeDirection(){
        self.drivingDirectionView.background = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 0.7)
        self.walkingDirectionView.background = Colors.colorDarkTransparent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}