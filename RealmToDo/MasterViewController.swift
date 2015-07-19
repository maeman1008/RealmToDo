//
//  MasterViewController.swift
//  RealmToDo
//
//  Created by Maeda Ryoto on 2015/07/20.
//  Copyright (c) 2015年 Maeda Ryoto. All rights reserved.
//

import UIKit
import RealmSwift

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    
    var items = Realm().objects(Item)

    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show items
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "CellIdentifier")
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        //add button actions call：showAlert
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "showAlert")
        
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
    }

    func showAlert() {
        let alertController = UIAlertController(title: "Create ToDo Item", message: "please input todo title.", preferredStyle: .Alert)
        
        alertController.addTextFieldWithConfigurationHandler(nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let otherAction = UIAlertAction(title: "Register", style: .Default){
            [unowned self] action in
            if let textFields = alertController.textFields {
                let textFields = textFields[0] as! UITextField
                self.insertNewObject(textFields.text)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(otherAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertNewObject(name: String) {
        
        let newItem = Item()
        
        newItem.name = name
        
        let realm = Realm()
        
        realm.write {
            realm.add(newItem)
        }
        
        tableView.reloadData()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let item = items[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = item
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        // show items.name
        let item = items[indexPath.row]
        cell.textLabel!.text = item.name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

