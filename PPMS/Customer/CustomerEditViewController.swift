//
//  CustomerEditViewController.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class CustomerEditViewController: FormViewController {

    var customerObj: Customer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if customerObj == nil {
           customerObj = Customer()
        }
        
        form +++ Section("Information")
            <<< TextRow("Company"){ row in
                row.title = "Company"
                row.placeholder = "Company Name"
                if (customerObj?.Company.characters.count)! > 0 {
                    row.value = customerObj?.Company
                }
            }
            <<< NameRow("ContactName"){ row in
                row.title = "Contact Name"
                row.placeholder = "Person You Contact"
                if((customerObj?.ContactName.characters.count)! > 0){
                    row.value = customerObj?.ContactName
                }
            }
            <<< TextRow("Email"){ row in
                row.title = "Email"
                row.placeholder = "Email"
                row.add(rule: RuleEmail())
                row.validationOptions = .validatesOnChange
                if (customerObj?.Email.characters.count)! > 0{
                    row.value = customerObj?.Email
                }
                }.cellUpdate{ cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
            }
            <<< PhoneRow("Phone"){
                $0.title = "Phone"
                $0.placeholder = "numbers here"
                if (customerObj?.Phone.characters.count)! > 0{
                    $0.value = customerObj?.Phone
                }
            }
            <<< PhoneRow("Fax"){
                $0.title = "Fax"
                $0.placeholder = "numbers here"
                if (customerObj?.Fax.characters.count)! > 0{
                    $0.value = customerObj?.Fax
                }
            }
            +++ Section("Address")
            <<< TextRow("Address1"){ row in
                row.title = "Address 1"
                row.placeholder = "Address 1"
                if (customerObj?.Address1.characters.count)! > 0{
                    row.value = customerObj?.Address1
                }
            }
            <<< TextRow("Address2"){ row in
                row.title = "Address 2"
                row.placeholder = "Address 2"
                if (customerObj?.Address2.characters.count)! > 0{
                    row.value = customerObj?.Address2
                }
            }
            <<< TextRow("City"){ row in
                row.title = "City"
                row.placeholder = "City"
                if (customerObj?.City.characters.count)! > 0{
                    row.value = customerObj?.City
                }
            }
            <<< TextRow("State"){ row in
                row.title = "State"
                row.placeholder = "State"
                if (customerObj?.State.characters.count)! > 0{
                    row.value = customerObj?.State
                }
            }
            <<< ZipCodeRow("Zip"){ row in
                row.title = "Zip"
                row.placeholder = "Your Zip Code"
                if (customerObj?.Zip.characters.count)! > 0{
                    row.value = customerObj?.Zip
                }
            }
            +++ Section("Others")
            <<< TextAreaRow("Memo"){ row in
                row.title = "Memo"
                row.placeholder = "Please enter Memo here"
                if (customerObj?.Memo.characters.count)! > 0{
                    row.value = customerObj?.Memo
                }
            }
            +++ Section("Actions")
            <<< ButtonRow("Save"){
                $0.title = "Save"
                }.onCellSelection { [weak self] (cell, row) in
                    self?.Save()
                    _ = self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func updateObject() {
        if customerObj == nil{
            customerObj = Customer()
        }
        
        
        let valuesDictionary = form.values()
        
        var strVal = valuesDictionary["Company"]
        
        if (strVal as? String != nil) {
            customerObj?.Company = strVal as! String
        }
        
        strVal = valuesDictionary["ContactName"]
        if (strVal as? String != nil) {
            customerObj?.ContactName = strVal as! String
        }
        
        strVal = valuesDictionary["Address1"]
        if (strVal as? String != nil) {
            customerObj?.Address1 = strVal as! String
        }
        
        strVal = valuesDictionary["Address2"]
        if (strVal as? String != nil) {
            customerObj?.Address2 = strVal as! String
        }
        
        strVal = valuesDictionary["City"]
        if (strVal as? String != nil) {
            customerObj?.City = strVal as! String
        }
        
        strVal = valuesDictionary["State"]
        if (strVal as? String != nil) {
            customerObj?.State = strVal as! String
        }
        
        strVal = valuesDictionary["Zip"]
        if (strVal as? String != nil) {
            customerObj?.Zip = strVal as! String
        }
        
        strVal = valuesDictionary["Email"]
        if (strVal as? String != nil) {
            customerObj?.Email = strVal as! String
        }
        
        strVal = valuesDictionary["Phone"]
        if (strVal as? String != nil) {
            customerObj?.Phone = strVal as! String
        }
        
        strVal = valuesDictionary["Fax"]
        if (strVal as? String != nil) {
            customerObj?.Fax = strVal as! String
        }
        
        strVal = valuesDictionary["Memo"]
        if (strVal as? String != nil) {
            customerObj?.Memo = strVal as! String
        }
    }
    
    func Save() {
        updateObject()
        
        let realm = try! Realm()
        
        let dtls = realm.objects(Customer.self).filter("Guid = %@", (customerObj?.Guid)!)
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(Customer.self).filter("Guid = %@", (customerObj?.Guid)!).first
            try! realm.write {
                theDtl!.Company = (customerObj?.Company)!
                theDtl!.ContactName = (customerObj?.ContactName)!
                theDtl!.Address1 = (customerObj?.Address1)!
                theDtl!.Address2 = (customerObj?.Address2)!
                theDtl!.State = (customerObj?.State)!
                theDtl!.Zip = (customerObj?.Zip)!
                theDtl!.Email = (customerObj?.Email)!
                theDtl!.Phone = (customerObj?.Phone)!
                theDtl!.Fax = (customerObj?.Fax)!
                theDtl!.Memo = (customerObj?.Memo)!
            }
        }else{
            //insert a new one
            try! realm.write {
                let theDtl = Customer()
                theDtl.Company = (customerObj?.Company)!
                theDtl.ContactName = (customerObj?.ContactName)!
                theDtl.Address1 = (customerObj?.Address1)!
                theDtl.Address2 = (customerObj?.Address2)!
                theDtl.City = (customerObj?.City)!
                theDtl.State = (customerObj?.State)!
                theDtl.Zip = (customerObj?.Zip)!
                theDtl.Email = (customerObj?.Email)!
                theDtl.Phone = (customerObj?.Phone)!
                theDtl.Fax = (customerObj?.Fax)!
                theDtl.Memo = (customerObj?.Memo)!
                realm.add(customerObj!)
            }
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //segueUnwindToList
        if (segue.identifier == "segueUnwindToList") {
            
            //self.Save()
        }
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
