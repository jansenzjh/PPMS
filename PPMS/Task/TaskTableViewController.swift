//
//  TaskTableViewController.swift
//  PPMS
//
//  Created by Jansen on 2/22/17.
//  Copyright © 2017 Jansen. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController, TaskTableViewCellDelegate{
    
    var toDoItems = [ToDoItem]()
    var projectGID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 50.0
        
        self.tableView.backgroundColor = UIColor.white
        self.tableView.delegate = self
        
        
        if self.projectGID.characters.count > 0{
            let tasks = Task().GetAllByProjectGID(guid: projectGID)
            
            for task in tasks{
                toDoItems.append(ToDoItem(task: task))
            }
        }
        
        if toDoItems.count == 0{
            self.navigationItem.title = "Pull down to add"
        }else{
            self.navigationItem.title = "Tasks"
        }
        
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
        return self.toDoItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskcell", for: indexPath) as! TaskTableViewCell
        
        // Configure the cell...
        let item = self.toDoItems[indexPath.row]
        cell.textLabel?.text = ""
        //cell.textLabel?.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.delegate = self
        cell.toDoItem = item
        cell.addSubview(cell.tickLabel)
        cell.addSubview(cell.crossLabel)
        cell.label.delegate = cell
        cell.label.contentVerticalAlignment = .center
        cell.tickLabel.isHidden = true
        cell.crossLabel.isHidden = true
        return cell
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = toDoItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(index: indexPath.row)
    }
    
    
    // MARK: - TableViewCellDelegate methods
    
    
    
    func toDoItemDeleted(todoItem toDoItem: ToDoItem) {
        let index = (toDoItems as NSArray).index(of: toDoItem)
        if index == NSNotFound { return }
        
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        let td = toDoItems[index]
        Task().Delete(guid: td.guid)
        toDoItems.remove(at: index)
        
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        let indexPathForRow = NSIndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPathForRow as IndexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func cellDidBeginEditing(editingCell: TaskTableViewCell) {
        //self.navigationController?.isNavigationBarHidden = true
        let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y + tableView.rowHeight as CGFloat
        let visibleCells = tableView.visibleCells as! [TaskTableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(editingCell: TaskTableViewCell) {
        //self.navigationController?.isNavigationBarHidden = false
        let visibleCells = tableView.visibleCells as! [TaskTableViewCell]
        for cell: TaskTableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = .identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
    }
    
    // MARK: - UIScrollViewDelegate methods
    // a cell that is rendered as a placeholder to indicate where a new item is added
    let placeHolderCell = TaskTableViewCell(style: .default, reuseIdentifier: "taskcell")
    // indicates the state of this behavior
    var pullDownInProgress = false
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // this behavior starts when a user pulls down while at the top of the table
        pullDownInProgress = scrollView.contentOffset.y <= 0.0
        placeHolderCell.backgroundColor = UIColor.red
        if pullDownInProgress {
            // add the placeholder
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentOffsetY = scrollView.contentOffset.y
        
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
            // maintain the location of the placeholder
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight,
                                           width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.label.text = -scrollViewContentOffsetY > tableView.rowHeight ?
                "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        } else {
            pullDownInProgress = false
        }
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight {
            // TODO – add a new item
            self.toDoItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    
    // MARK: - add, delete, edit methods
    
    func toDoItemAdded() {
        let task = Task()
        task.ProjectGID = self.projectGID
        let toDoItem = ToDoItem(task: task)
        toDoItems.insert(toDoItem, at: 0)
        tableView.reloadData()
        // enter edit mode
        var editCell: TaskTableViewCell
        let visibleCells = tableView.visibleCells as! [TaskTableViewCell]
        for cell in visibleCells {
            if (cell.toDoItem === toDoItem) {
                editCell = cell
                editCell.label.becomeFirstResponder()
                break
            }
        }
    }

    
}











