//
//  RestaurantViewCell.swift
//  ting
//
//  Created by Christian Scott on 12/09/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class RestaurantViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellId = "cellId"
    
    let numberFormatter = NumberFormatter()
    
    let viewCell: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = Colors.colorVeryLightGray.cgColor
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let restaurantImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 4
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
    
    lazy var restaurantMenusView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.colorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
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
    
    let restaurantDataView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let restaurantLikesView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "2,873"
        view.icon = UIImage(named: "icon_like_outline_25_gray")!
        return view
    }()
    
    let restaurantReviewsView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "876"
        view.icon = UIImage(named: "icon_star_outline_25_gray")!
        return view
    }()
    
    let restaurantSpecialsView: IconTextView = {
        let view = IconTextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "4"
        view.icon = UIImage(named: "icons-plus_filled_25_gray")!
        return view
    }()
    
    var branch: Branch? {
        didSet {
            numberFormatter.numberStyle = .decimal
            if let branch = self.branch {
                self.restaurantImageView.load(url: URL(string: "\(URLs.hostEndPoint)\(branch.restaurant!.logo)")!)
                self.restaurantImageView.alpha = 1.0
                self.restaurantName.text = "\(branch.restaurant!.name), \(branch.name)"
                self.restaurantRating.rating = Double(branch.reviews?.average ?? 0)
                self.restaurantAddress.text = branch.address
                self.restaurantDistanceView.text = "\(numberFormatter.string(from: NSNumber(value: branch.dist ?? 0.00)) ?? "0.00") km"
                self.restaurantLikesView.text = numberFormatter.string(from: NSNumber(value: branch.likes!.count)) ?? "0"
                self.restaurantReviewsView.text = numberFormatter.string(from: NSNumber(value: branch.reviews!.count)) ?? "0"
                self.restaurantSpecialsView.text = String(branch.specials.count)
                self.setTimeStatus()
            }
            self.setup()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    private func setup(){
        addSubview(viewCell)
        
        numberFormatter.numberStyle = .decimal
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: viewCell)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: viewCell)
        
        restaurantAddressView.addSubview(iconAddressImageView)
        restaurantAddressView.addSubview(restaurantAddress)
        
        restaurantAddressView.addConstraintsWithFormat(format: "H:|[v0(14)]-4-[v1]|", views: iconAddressImageView, restaurantAddress)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0(14)]|", views: iconAddressImageView)
        restaurantAddressView.addConstraintsWithFormat(format: "V:|[v0]|", views: restaurantAddress)
        
        restaurantMenusView.register(RestaurantViewCellMenuViewCell.self, forCellWithReuseIdentifier: cellId)
        if let flowLayout = restaurantMenusView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 8
        }
        
        restaurantMenusView.showsHorizontalScrollIndicator = false
        restaurantMenusView.showsVerticalScrollIndicator = false
        
        restaurantStatusView.addSubview(restaurantDistanceView)
        restaurantStatusView.addSubview(restaurantTimeStatusView)
        
        let iconTextViewConstant: CGFloat = 37
        let restaurantDistanceViewWidth = iconTextViewConstant + restaurantDistanceView.textView.intrinsicContentSize.width
        let restaurantStatusTimeViewWidth = iconTextViewConstant + restaurantTimeStatusView.textView.intrinsicContentSize.width
        
        let _ = (37 * 2) + 8 + restaurantDistanceViewWidth + restaurantStatusTimeViewWidth
        
        restaurantStatusView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]", views: restaurantDistanceView, restaurantTimeStatusView)
        restaurantStatusView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantDistanceView)
        restaurantStatusView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantTimeStatusView)
        
        restaurantDataView.addSubview(restaurantLikesView)
        restaurantDataView.addSubview(restaurantReviewsView)
        restaurantDataView.addSubview(restaurantSpecialsView)
        
        let restaurantLikesViewWidth = iconTextViewConstant + restaurantLikesView.textView.intrinsicContentSize.width
        let restaurantReviewsViewWidth = iconTextViewConstant + restaurantReviewsView.textView.intrinsicContentSize.width
        let restaurantSpecialsViewWidth = iconTextViewConstant + restaurantSpecialsView.textView.intrinsicContentSize.width
        
        let _ = (37 * 3) + 16 + restaurantLikesViewWidth + restaurantReviewsViewWidth + restaurantSpecialsViewWidth
        
        restaurantDataView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1]-8-[v2]", views: restaurantLikesView, restaurantReviewsView, restaurantSpecialsView)
        restaurantDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantLikesView)
        restaurantDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantReviewsView)
        restaurantDataView.addConstraintsWithFormat(format: "V:|[v0(26)]|", views: restaurantSpecialsView)
        
        restaurantProfileView.addSubview(restaurantName)
        restaurantProfileView.addSubview(restaurantRating)
        restaurantProfileView.addSubview(restaurantAddressView)
        restaurantProfileView.addSubview(restaurantMenusView)
        restaurantProfileView.addSubview(restaurantStatusView)
        restaurantProfileView.addSubview(restaurantDataView)
        
        restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantName)
        restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantRating)
        restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantAddressView)
        restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantMenusView)
        restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantStatusView)
        restaurantProfileView.addConstraintsWithFormat(format: "H:|[v0]|", views: restaurantDataView)
        restaurantProfileView.addConstraintsWithFormat(format: "V:|[v0]-2-[v1]-4-[v2]-8-[v3(45)]-8-[v4(26)]-8-[v5(26)]-12-|", views: restaurantName, restaurantRating, restaurantAddressView, restaurantMenusView, restaurantStatusView, restaurantDataView)
        
        viewCell.addSubview(restaurantImageView)
        viewCell.addSubview(restaurantProfileView)
        
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0(80)]", views: restaurantImageView)
        viewCell.addConstraintsWithFormat(format: "V:|-12-[v0]", views: restaurantProfileView)
        viewCell.addConstraintsWithFormat(format: "H:|-12-[v0(80)]-12-[v1]-12-|", views: restaurantImageView, restaurantProfileView)
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(setTimeStatus), userInfo: nil, repeats: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.branch?.menus.count ?? 0 >= 4 ? 4 : self.branch?.menus.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RestaurantViewCellMenuViewCell
        cell.menu = self.branch?.menus.menus?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 45)
    }
    
    @objc private func setTimeStatus(){
        if let branch = self.branch {
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
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RestaurantViewCellMenuViewCell: UICollectionViewCell {
    
    let menuImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.4
        view.image = UIImage(named: "default_meal")
        return view
    }()
    
    var menu: RestaurantMenu? {
        didSet {
            if let menu = self.menu {
                let images = menu.menu?.images?.images
                let image = images![Int.random(in: 0...images!.count - 1)]
                self.menuImageView.load(url: URL(string: "\(URLs.hostEndPoint)\(image.image)")!)
                self.menuImageView.alpha = 1.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(menuImageView)
        addConstraintsWithFormat(format: "H:|[v0(\(frame.width))]|", views: menuImageView)
        addConstraintsWithFormat(format: "V:|[v0(\(frame.height))]|", views: menuImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
