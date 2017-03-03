//
//  ProjectTableViewController.swift
//  PPMS
//
//  Created by Jansen on 2/19/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import SwiftDate
import KRAlertController
import GSMessages

class ProjectTableViewController: UITableViewController, SwipeTableViewCellDelegate {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectTableViewCell
        
        // Configure the cell...
        let proj = ProjectList[indexPath.row]
        cell.projectGID = proj.Guid
        cell.lblCustName?.text = Customer().GetByGUID(guid: proj.CustomerGID).Company
        cell.lblProjName?.text = proj.Name
        cell.lblProjDesc?.text = proj.Description
        cell.lblProjDateRange?.text = (proj.StartDate.string(format: .custom("MM/dd")))
            + " - "
            + (proj.EndDate.string(format: .custom("MM/dd")))
        cell.delegate = self
        return cell
    }
    
    //SwipeTableViewCell Delegate
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        
        if orientation == .left {
            
            let bill = SwipeAction(style: .default, title: "Bill") { action, indexPath in
                
                let cell = tableView.cellForRow(at: indexPath) as! ProjectTableViewCell
                KRAlertController(title: "Bill Project", message: "You are abou to create a bill for this Project. Are you sure?")
                    .addCancel(title: "Cancel"){action, textFields in
                        cell.hideSwipe(animated: true)
                    }
                    .addAction(title: "Yes") { action, textFields in
                        Project().BillProject(projectGID: cell.projectGID)
                        self.showMessage("Billed Success!", type: .success)
                        cell.hideSwipe(animated: true)
                    }
                    .showInformation(icon: true)
                
                
            }
            bill.backgroundColor = view.tintColor
            bill.image = UIImage.fontAwesomeIcon(name: .money, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
            return [bill]
        } else {
            let delete = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                let cell = tableView.cellForRow(at: indexPath) as! ProjectTableViewCell
                KRAlertController(title: "Delete Project", message: "You are about to delete this Project. All tasks with this project will be deleted as well. Are you sure?")
                    .addCancel(title: "Cancel"){action, textFields in
                        cell.hideSwipe(animated: true)
                    }
                    .addAction(title: "Yes") { action, textFields in
                        let obj = self.ProjectList[indexPath.row]
                        Project().Delete(guid: obj.Guid)
                        self.ProjectList.remove(at: indexPath.row)
                        self.showMessage("Delete Success!", type: .success)
                        cell.hideSwipe(animated: true)
                        self.tableView.reloadData()
                    }
                    .showWarning(icon: true)
                
            }
            delete.image = UIImage.fontAwesomeIcon(name: .trash, textColor: UIColor.white, size: CGSize(width: 25, height: 25))
            
            
            
            
            return [delete]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
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
            theDtl.Status = projectObj.Status
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
