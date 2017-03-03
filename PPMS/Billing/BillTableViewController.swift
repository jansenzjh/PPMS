//
//  BillTableViewController.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate
import Format

class BillTableViewController: UITableViewController {
    
    @IBAction func unwindToCustList(segue: UIStoryboardSegue) {
        LoadData()
        self.tableView.reloadData()
    }
    
    var billList = [Bill]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.LoadData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        LoadData()
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.billList.count
    }
    
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let obj = self.billList[indexPath.row]
            Bill().Delete(guid: obj.Guid)
            billList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
 
    
    func LoadData() {
        let realm = try! Realm()
        
        let cl = realm.objects(Bill.self).sorted(byKeyPath: "TransactionDate")
        self.billList = Array(cl)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billcell", for: indexPath)
        
        // Configure the cell...
        let bl = billList[indexPath.row]
        cell.textLabel?.text = bl.TransactionDate.string(format: .custom("MM/dd")) + " " + bl.Amount.format(Currency.USD)
        cell.detailTextLabel?.text = Project().GetProjectNameByGuid(guid: bl.ProjectGID)
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "editBillSegue"){
            let destView = segue.destination as! BillEditViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let c = billList[(indexPath?.row)!]
            
            let theDtl = Bill()
            theDtl.Guid = c.Guid
            theDtl.CreateDate = (c.CreateDate)
            theDtl.TransactionDate = (c.TransactionDate)
            theDtl.Notes = (c.Notes)
            theDtl.Amount = c.Amount
            theDtl.IsCompleted = (c.IsCompleted)
            theDtl.ProjectGID = (c.ProjectGID)
            theDtl.CustomerGID = c.CustomerGID
            theDtl.TransactionType = c.TransactionType
            destView.billObj = theDtl
            
            
            
        }
    }
    
    
}
