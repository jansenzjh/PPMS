//
//  ProjectTableViewController.swift
//  PPMS
//
//  Created by Jansen on 2/19/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import RealmSwift

class ProjectTableViewController: UITableViewController {

    var ProjectList = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return self.ProjectList.count
    }
    
    func LoadData() {
        let realm = try! Realm()
        
        let cl = realm.objects(Project.self)
        self.ProjectList = Array(cl)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = ProjectList[indexPath.row].Name
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "editProjectSegue"){
            let destView = segue.destination as! ProjectEditViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let projectObj = ProjectList[(indexPath?.row)!]
            
            let theDtl = Project()
            theDtl.Guid = projectObj.Guid
            theDtl.Name = projectObj.Name
            theDtl.StartDate = projectObj.StartDate
            theDtl.EndDate = projectObj.EndDate
            theDtl.Description = projectObj.Description
            theDtl.Priority = projectObj.Priority
            theDtl.Category = projectObj.Category
            theDtl.CustomerGID = projectObj.CustomerGID
            theDtl.Notes = projectObj.Notes
            theDtl.BillTypes = projectObj.BillTypes
            theDtl.BillRatePerHour = projectObj.BillRatePerHour
            theDtl.FixedPrice = projectObj.FixedPrice
            destView.projectObj = theDtl
        }
    }
}
