//
//  HomeMenuViewController.swift
//  ting
//
//  Created by Ir Christian Scott on 19/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import UIKit

class HomeMenuViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var userProfileImageView: CircularImageView!
    @IBOutlet weak var userProfileNameLabel: UILabel!
    @IBOutlet weak var userProfileEmailLabel: UILabel!
    
    @IBOutlet weak var settingsIconView: UIView!
    @IBOutlet weak var settingsIconImage: UIImageView!
    
    @IBOutlet weak var userProfileItemMenuView: UIView!
    @IBOutlet weak var userMomentsItemMenuView: UIView!
    @IBOutlet weak var userRestaurantsItemMenuView: UIView!
    
    let user = UserAuthentication().get()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfileNameLabel.text = user!.name
        userProfileEmailLabel.text = user!.email
        userProfileImageView.load(url: URL(string: "\(URLs.uploadEndPoint)\(user!.image)")!)
        
        settingsIconView.backgroundColor = Colors.colorDarkTransparent
        settingsIconView.layer.cornerRadius = settingsIconView.frame.size.height / 2
        settingsIconView.layer.masksToBounds = true
        settingsIconImage.alpha = 0.6
        
        self.navigationItem.title = user!.username
        
        if let window = UIApplication.shared.keyWindow {
            self.scrollView.contentSize = CGSize(width: window.frame.width, height: 610)
        }
        
        self.navigationController?.navigationBar.backgroundColor = Colors.colorWhite
        self.navigationController?.navigationBar.barTintColor = Colors.colorWhite
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.clear], for: .normal)
        
        let navigateUserProfileTap = UITapGestureRecognizer(target: self, action: #selector(navigateUserProfile(gestureRecognizer:)))
        self.userProfileItemMenuView.addGestureRecognizer(navigateUserProfileTap)
        
        let navigateUserRestaurantsTap = UITapGestureRecognizer(target: self, action: #selector(navigateUserRestaurants(gestureRecognizer:)))
        self.userRestaurantsItemMenuView.addGestureRecognizer(navigateUserRestaurantsTap)
        
        let navigateUserMomentsTap = UITapGestureRecognizer(target: self, action: #selector(navigateUserMoments(gestureRecognizer:)))
        self.userMomentsItemMenuView.addGestureRecognizer(navigateUserMomentsTap)
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = Colors.colorWhite
        self.navigationController?.navigationBar.barTintColor = Colors.colorWhite
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationItem.title = user!.username
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Colors.colorDarkGray]
        
        let barButtonAppearance = UIBarButtonItem.appearance()
        barButtonAppearance.setTitleTextAttributes([.foregroundColor : UIColor.clear], for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setupNavigationBar()
    }
    
    func navigateToUser(tab: Int){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let userViewController = storyboard.instantiateViewController(withIdentifier: "UserView") as! UserViewController
        userViewController.user = user
        userViewController.selectedTab = tab
        self.navigationController?.pushViewController(userViewController, animated: true)
    }
    
    @objc func navigateUserProfile(gestureRecognizer: UITapGestureRecognizer){
        self.navigateToUser(tab: 2)
    }
    
    @objc func navigateUserRestaurants(gestureRecognizer: UITapGestureRecognizer){
        self.navigateToUser(tab: 1)
    }
    
    @objc func navigateUserMoments(gestureRecognizer: UITapGestureRecognizer){
        self.navigateToUser(tab: 0)
    }
}
