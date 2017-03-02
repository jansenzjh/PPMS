//
//  TimeClockTableViewController.swift
//  PPMS
//
//  Created by Jansen on 2/20/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate

class TimeClockTableViewController: UITableViewController {
    
    @IBAction func unwindToCustList(segue: UIStoryboardSegue) {
        LoadData()
        self.tableView.reloadData()
    }
    
    var timeClockList = [TimeClock]()
    
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
        return self.timeClockList.count
    }
    
    func LoadData() {
        let realm = try! Realm()
        
        let cl = realm.objects(TimeClock.self)
        self.timeClockList = Array(cl)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeclockCell", for: indexPath)
        
        // Configure the cell...
        let ed = timeClockList[indexPath.row].EndDate
        let sd = timeClockList[indexPath.row].StartDate
        cell.textLabel?.text = (sd?.string(format: .custom("MM/dd hh:mm")))! + " - " + (ed?.string(format: .custom("MM/dd hh:mm")))!
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "editTimeClockSegue"){
            let destView = segue.destination as! TimeClockEditViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let c = timeClockList[(indexPath?.row)!]
            
            let theDtl = TimeClock()
            theDtl.Guid = c.Guid
            theDtl.StartDate = (c.StartDate)
            theDtl.EndDate = (c.EndDate)
            theDtl.Description = (c.Description)
            theDtl.IsClockIn = (c.IsClockIn)
            theDtl.ProjectGID = (c.ProjectGID)
            destView.timeClockObj = theDtl
            
            
        }
    }
    
    
}
