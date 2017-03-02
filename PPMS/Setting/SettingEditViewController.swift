//
//  SettingEditViewController.swift
//  PPMS
//
//  Created by Jansen on 2/28/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import Eureka
import GSMessages

class SettingEditViewController: FormViewController {

    var settingObj = Setting().LoadSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var Company = ""
//        var UserName = ""
//        var UserAddress1 = ""
//        var UserAddress2 = ""
//        var City = ""
//        var State = ""
//        var Country = ""
//        var Zip = ""
//        var Email = ""
//        var Phone = ""

        form +++ Section("Information")
            <<< TextRow("Company"){ row in
                row.title = "Company"
                row.placeholder = "Company Name"
                if (settingObj.Company.characters.count) > 0 {
                    row.value = settingObj.Company
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .idCard, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< NameRow("UserName"){ row in
                row.title = "Name"
                row.placeholder = "You Name"
                if((settingObj.UserName.characters.count) > 0){
                    row.value = settingObj.UserName
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .userCircle, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< TextRow("Email"){ row in
                row.title = "Email"
                row.placeholder = "Email"
                row.add(rule: RuleEmail())
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .envelope, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                row.validationOptions = .validatesOnChange
                if (settingObj.Email.characters.count) > 0{
                    row.value = settingObj.Email
                }
                }.cellUpdate{ cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< PhoneRow("Phone"){
                $0.title = "Phone"
                $0.placeholder = "numbers here"
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .phoneSquare, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                if (settingObj.Phone.characters.count) > 0{
                    $0.value = settingObj.Phone
                }
            }
            +++ Section("Address")
            <<< TextRow("Address1"){ row in
                row.title = "Address 1"
                row.placeholder = "Address 1"
                if (settingObj.UserAddress1.characters.count) > 0{
                    row.value = settingObj.UserAddress1
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .addressBook, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< TextRow("Address2"){ row in
                row.title = "Address 2"
                row.placeholder = "Address 2"
                if (settingObj.UserAddress2.characters.count) > 0{
                    row.value = settingObj.UserAddress2
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .addressBook, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }
            <<< TextRow("City"){ row in
                row.title = "City"
                row.placeholder = "City"
                if (settingObj.City.characters.count) > 0{
                    row.value = settingObj.City
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .locationArrow, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< TextRow("State"){ row in
                row.title = "State"
                row.placeholder = "State"
                if (settingObj.State.characters.count) > 0{
                    row.value = settingObj.State
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .mapMarker, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< TextRow("Country"){ row in
                row.title = "Country"
                row.placeholder = "Country"
                if (settingObj.Country.characters.count) > 0{
                    row.value = settingObj.Country
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .globe, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< ZipCodeRow("Zip"){ row in
                row.title = "Zip"
                row.placeholder = "Your Zip Code"
                if (settingObj.Zip.characters.count) > 0{
                    row.value = settingObj.Zip
                }
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .envelope, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            +++ Section("Actions")
            <<< ButtonRow("Save"){
                $0.title = "Save"
                }.onCellSelection { [weak self] (cell, row) in
                    self?.Save()
                    self?.showMessage("Setting Save Success", type: .success)
        }
    }

    func updateObject() {
        
        let valuesDictionary = form.values()
        
        var strVal = valuesDictionary["Company"]
        
        if (strVal as? String != nil) {
            settingObj.Company = strVal as! String
        }
        
        strVal = valuesDictionary["UserName"]
        if (strVal as? String != nil) {
            settingObj.UserName = strVal as! String
        }
        
        strVal = valuesDictionary["Address1"]
        if (strVal as? String != nil) {
            settingObj.UserAddress1 = strVal as! String
        }
        
        strVal = valuesDictionary["Address2"]
        if (strVal as? String != nil) {
            settingObj.UserAddress1 = strVal as! String
        }
        
        strVal = valuesDictionary["City"]
        if (strVal as? String != nil) {
            settingObj.City = strVal as! String
        }
        
        strVal = valuesDictionary["State"]
        if (strVal as? String != nil) {
            settingObj.State = strVal as! String
        }
        strVal = valuesDictionary["Country"]
        if (strVal as? String != nil) {
            settingObj.Country = strVal as! String
        }
        
        strVal = valuesDictionary["Zip"]
        if (strVal as? String != nil) {
            settingObj.Zip = strVal as! String
        }
        
        strVal = valuesDictionary["Email"]
        if (strVal as? String != nil) {
            settingObj.Email = strVal as! String
        }
        
        strVal = valuesDictionary["Phone"]
        if (strVal as? String != nil) {
            settingObj.Phone = strVal as! String
        }
        
        
    }
    
    func Save() {
        updateObject()
        settingObj.SaveSettings(set: settingObj)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
