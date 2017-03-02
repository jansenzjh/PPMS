//
//  TaskProjectListTableViewController.swift
//  PPMS
//
//  Created by Jansen on 2/22/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit
import RealmSwift

class TaskProjectListTableViewController: UITableViewController {

    var ProjectList = [Project]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        return self.ProjectList.count
    }
    
    func LoadData() {
        let realm = try! Realm()
        
        let cl = realm.objects(Project.self)
        self.ProjectList = Array(cl)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskprojectcell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = ProjectList[indexPath.row].Name
        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "projectTaskSegue"){
            let destView = segue.destination as! TaskTableViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            
            let p = ProjectList[(indexPath?.row)!]
            
            destView.projectGID = p.Guid
            
            
        }
        
    }
 

}
