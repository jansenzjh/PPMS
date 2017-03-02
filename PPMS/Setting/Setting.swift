//
//  Setting.swift
//  PMS
//
//  Created by Jansen on 7/24/16.
//  Copyright © 2016 Jansen. All rights reserved.
//

import Foundation

class Setting: NSObject{
    
    var Company = ""
    var UserName = ""
    var UserAddress1 = ""
    var UserAddress2 = ""
    var City = ""
    var State = ""
    var Country = ""
    var Zip = ""
    var Email = ""
    var Phone = ""
    
    func SaveSettings(set: Setting){
        let defaults = UserDefaults.standard
        defaults.setValue(set.Company, forKey: "settingCompany")
        defaults.setValue(set.UserName, forKey: "settingUserName")
        defaults.setValue(set.UserAddress1, forKey: "settingUserAddress1")
        defaults.setValue(set.UserAddress2, forKey: "settingUserAddress2")
        defaults.setValue(set.City, forKey: "settingCity")
        defaults.setValue(set.State, forKey: "settingState")
        defaults.setValue(set.Country, forKey: "settingCountry")
        defaults.setValue(set.Zip, forKey: "settingZip")
        defaults.setValue(set.Email, forKey: "settingEmail")
        defaults.setValue(set.Phone, forKey: "settingPhone")
        
    }
    
    func LoadSettings() -> Setting{
        let defaults = UserDefaults.standard
        let setting = Setting()
        
        if let str = defaults.string(forKey: "settingCompany"){
            setting.Company = str
        }
        if let str = defaults.string(forKey: "settingUserName"){
            setting.UserName = str
        }
        if let str = defaults.string(forKey: "settingUserAddress1"){
            setting.UserAddress1 = str
        }
        if let str = defaults.string(forKey: "settingUserAddress2"){
            setting.UserAddress2 = str
        }
        if let str = defaults.string(forKey: "settingCity"){
            setting.City = str
        }
        if let str = defaults.string(forKey: "settingState"){
            setting.State = str
        }
        if let str = defaults.string(forKey: "settingCountry"){
            setting.Country = str
        }
        if let str = defaults.string(forKey: "settingZip"){
            setting.Zip = str
        }
        if let str = defaults.string(forKey: "settingEmail"){
            setting.Email = str
        }
        if let str = defaults.string(forKey: "settingPhone"){
            setting.Phone = str
        }
        return setting
    }
    
    
}
