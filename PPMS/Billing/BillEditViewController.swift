//
//  BillEditViewController.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift
import MessageUI

class BillEditViewController: FormViewController, MFMailComposeViewControllerDelegate {
    
    var billObj: Bill? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if billObj == nil {
            billObj = Bill()
        }
        
        form +++ Section("Timing")
            <<< DateTimeInlineRow("CreateDate"){ row in
                row.title = "Create Date"
                row.value = billObj?.CreateDate as Date?
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< DateTimeInlineRow("TransactionDate"){ row in
                row.title = "Transaction Date"
                row.value = billObj?.TransactionDate as Date?
            }
            <<< PushRow<String>("ProjectGID") {
                let projs = Project().GetAllProjectName()
                $0.title = "Project"
                $0.options = projs
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .calendar, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                $0.value = Project().GetProjectNameByGuid(guid: (billObj?.ProjectGID)!)
                if projs.count == 0 {
                    $0.selectorTitle = "Please create Project first!"
                }else{
                    $0.selectorTitle = "Choose a Project"
                }
                
            }
            <<< PushRow<String>("CustomerGID") {
                let custs = Customer().GetAllName()
                $0.title = "Customer"
                $0.options = custs
                $0.value = Customer().GetByGUID(guid: (billObj?.CustomerGID)!).Company
                if custs.count == 0 {
                    $0.selectorTitle = "Please create customer!"
                }else{
                    $0.selectorTitle = "Choose a Customer"
                }
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .users, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }
            <<< DecimalRow("Amount"){ row in
                row.title = "Amount"
                row.placeholder = "What's your Amount?"
                row.value = billObj?.Amount
                row.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .money, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                
            }
            
            <<< SegmentedRow<String>("TransactionType"){
                $0.title = "Transaction Type"
                $0.value = billObj?.TransactionType
                $0.options = ["Order", "Invoice"]
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .sitemap, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< SwitchRow("IsCompleted"){
                $0.title = "Is Completed?"
                $0.value = billObj?.IsCompleted
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .checkCircle, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
            }
            <<< TextAreaRow("Notes"){ row in
                row.title = "Notes"
                row.placeholder = "Notes"
                if (billObj?.Notes.characters.count)! > 0{
                    row.value = billObj?.Notes
                }
            }
            
            
            +++ Section("Actions")
            <<< ButtonRow("Save"){
                $0.title = "Save"
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .save, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                }.onCellSelection { [weak self] (cell, row) in
                    self?.Save()
                    _ = self?.navigationController?.popViewController(animated: true)
        }
            <<< ButtonRow("Email"){
                $0.title = "Email"
                $0.baseCell.imageView?.image = UIImage.fontAwesomeIcon(name: .envelope, textColor: UIColor.gray, size: CGSize(width: 25, height: 25))
                }.onCellSelection { [weak self] (cell, row) in
                    self?.sendEmail()
        }
    }
    
    func updateObject() {
        if billObj == nil{
            billObj = Bill()
        }
        
        
        let valuesDictionary = form.values()
        
        var strVal = valuesDictionary["Notes"]
        
        if (strVal as? String != nil) {
            billObj?.Notes = strVal as! String
        }
        
        strVal = valuesDictionary["ProjectGID"]
        if (strVal as? String != nil) {
            strVal = Project().GetProjectGuidByName(name: strVal as! String)
            billObj?.ProjectGID = strVal as! String
        }
        strVal = valuesDictionary["CustomerGID"]
        if (strVal as? String != nil) {
            strVal = Customer().GetByName(name: strVal as! String).Guid
            billObj?.CustomerGID = strVal as! String
        }
        strVal = valuesDictionary["TransactionType"]
        if (strVal as? String != nil) {
            billObj?.TransactionType = strVal as! String
        }
        
        var dateVal = valuesDictionary["CreateDate"]
        
        if (dateVal as? Date != nil) {
            billObj?.CreateDate = (dateVal as? Date)!
        }
        
        dateVal = valuesDictionary["TransactionDate"]
        
        if (dateVal as? Date != nil) {
            billObj?.TransactionDate = (dateVal as? Date)!
        }
        
        billObj?.IsCompleted = valuesDictionary["IsCompleted"] as! Bool
        
        
        let doubleVal = valuesDictionary["Amount"]
        
        if (doubleVal as? Double != nil) {
            billObj?.Amount = doubleVal as! Double
        }
        
    }
    
    func Save() {
        updateObject()
        
        let realm = try! Realm()
        
        let dtls = realm.objects(Bill.self).filter("Guid = %@", (billObj?.Guid)!)
        if dtls.count > 0 {
            //existing history
            let theDtl = realm.objects(Bill.self).filter("Guid = %@", (billObj?.Guid)!).first
            try! realm.write {
                theDtl!.Guid = (billObj?.Guid)!
                theDtl!.CreateDate = (billObj?.CreateDate)!
                theDtl!.TransactionDate = (billObj?.TransactionDate)!
                theDtl!.Notes = (billObj?.Notes)!
                theDtl!.Amount = (billObj?.Amount)!
                theDtl!.IsCompleted = (billObj?.IsCompleted)!
                theDtl!.ProjectGID = (billObj?.ProjectGID)!
                theDtl!.CustomerGID = (billObj?.CustomerGID)!
                theDtl!.TransactionType = (billObj?.TransactionType)!
                
            }
        }else{
            //insert a new one
            try! realm.write {
                let theDtl = Bill()
                theDtl.Guid = (billObj?.Guid)!
                theDtl.CreateDate = (billObj?.CreateDate)!
                theDtl.TransactionDate = (billObj?.TransactionDate)!
                theDtl.Notes = (billObj?.Notes)!
                theDtl.Amount = (billObj?.Amount)!
                theDtl.IsCompleted = (billObj?.IsCompleted)!
                theDtl.ProjectGID = (billObj?.ProjectGID)!
                theDtl.CustomerGID = (billObj?.CustomerGID)!
                theDtl.TransactionType = (billObj?.TransactionType)!
                realm.add(billObj!)
                
                
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

    
    //Mark: - Email
    func sendEmail(){
        let trans = self.billObj
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let cust = Customer().GetByGUID(guid: (trans?.CustomerGID)!)
        mailComposerVC.setToRecipients([cust.Email])
        mailComposerVC.setSubject("Bill to " + Project().GetProjectNameByGuid(guid: (self.billObj?.ProjectGID)!))
        let htmlbody = getHTMLString(cust, trans: trans!)
        mailComposerVC.setMessageBody(htmlbody, isHTML: true)
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposerVC, animated: true, completion: nil)
        } else {
            //self.showSendMailErrorAlert()
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["someone@somewhere.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    func getHTMLString(_ cust: Customer, trans: Bill) -> String{
        let fileName = "billTemp"
        let DocumentDirURL = Bundle.main.bundleURL
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        print("FilePath: \(fileURL.path)")
        
        var inString = ""
        do {
            inString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        
        let st = Setting().LoadSettings()
        
        inString = inString.replacingOccurrences(of: "emailDate", with: Date().string(), options: NSString.CompareOptions.literal, range: nil)
        
        inString = inString.replacingOccurrences(of: "company1", with: st.Company, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "name1", with: st.UserName, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "addr11", with: st.UserAddress1, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "addr21", with: st.UserAddress2, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "email1", with: st.Email, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "phone1", with: st.Phone, options: NSString.CompareOptions.literal, range: nil)
        
        inString = inString.replacingOccurrences(of: "company2", with: cust.Company, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "name2", with: cust.ContactName, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "addr12", with: cust.Address1, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "addr22", with: cust.Address2, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "email2", with: cust.Email, options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "phone2", with: cust.Phone, options: NSString.CompareOptions.literal, range: nil)
        
        let prj = Project().GetProject(guid: trans.ProjectGID)
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        inString = inString.replacingOccurrences(of: "prj", with: prj.Name, options: NSString.CompareOptions.literal, range: nil)
        if prj.BillTypes == "Fixed Cost"{
            inString = inString.replacingOccurrences(of: "blltype", with: "Fixed", options: NSString.CompareOptions.literal, range: nil)
            inString = inString.replacingOccurrences(of: "qty", with: "1", options: NSString.CompareOptions.literal, range: nil)
            inString = inString.replacingOccurrences(of: "prz", with: formatter.string(from: prj.FixedPrice as NSNumber)!, options: NSString.CompareOptions.literal, range: nil)
            
        }else{
            inString = inString.replacingOccurrences(of: "blltype", with: "Hourly", options: NSString.CompareOptions.literal, range: nil)
            //inString = inString.replacingOccurrences(of: "qty", with: String(TimeClock().getTotalWorkingHours(prj.Guid)), options: NSString.CompareOptions.literal, range: nil)
            inString = inString.replacingOccurrences(of: "prz", with: String(prj.BillRatePerHour), options: NSString.CompareOptions.literal, range: nil)
            
        }
        inString = inString.replacingOccurrences(of: "amt", with: String(trans.Amount), options: NSString.CompareOptions.literal, range: nil)
        inString = inString.replacingOccurrences(of: "tot", with: String(trans.Amount), options: NSString.CompareOptions.literal, range: nil)
        
        
        
        
        
        return inString
    }
    
}
