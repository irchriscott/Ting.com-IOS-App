//
//  UserAuthentication.swift
//  ting
//
//  Created by Ir Christian Scott on 06/08/2019.
//  Copyright © 2019 Ir Christian Scott. All rights reserved.
//

import Foundation

class UserAuthentication : NSObject {
    
    let SESSION_USER_KEY = "session_user"
    
    override init() {
        super.init()
    }
    
    public func saveUserData(data: Data){
        UserDefaults.standard.set(data, forKey: SESSION_USER_KEY)
    }
    
    public func isUserLoggedIn() -> Bool {
        return UserDefaults.standard.object(forKey: SESSION_USER_KEY) != nil
    }
    
    public func saveSignUpData(key: String, data: String){
        UserDefaults.standard.set(data, forKey: key)
    }
    
    public func getSignUpData(key: String) -> String? {
        return UserDefaults.standard.object(forKey: key) as? String
    }
    
    public func get() -> User? {
        let data = UserDefaults.standard.data(forKey: SESSION_USER_KEY)
        do { return try JSONDecoder().decode(User.self, from: data!) } catch { return nil }
    }
    
}
