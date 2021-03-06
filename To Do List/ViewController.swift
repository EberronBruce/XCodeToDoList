//
//  ViewController.swift
//  To Do List
//
//  Created by Bruce Burgess on 2/22/16.
//  Copyright © 2016 Bruce Burgess. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Connect the storyboard table view
    @IBOutlet weak var tableView: UITableView!
    
    //Sets a text field for the alert
    var tField : UITextField!
    
    //set up an items array
    var items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set the data source and delegate to the view controller
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        //Setting the context as an AppDelegate to help manage coredata
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let request = NSFetchRequest(entityName: "Item")
        var results : [AnyObject]?
        
        do{
            results = try context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil {
            self.items = results as! [Item]
        }
        
        self.tableView.reloadData()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set up the number of rows in the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    //Set up the cells in the table view
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let item = self.items[indexPath.row]
        cell.textLabel!.text = item.title
        return cell
    }

    //Function for when the add button is pressed
    @IBAction func addButtonPressed(sender: AnyObject) {
        alertPopup()
    }
    
    func configurationTextField(textField: UITextField){
        textField.placeholder = "Enter new item"
        self.tField = textField
    }
    
    //Saves the item to memory
    func saveNewItem(){
        print("Item Save")
        
        //Setting the context as an AppDelegate to help manage coredata
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        //Creating an Entity for the item using the context as mananagement
        let item = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context) as! Item
        
        item.title = tField.text
        //Try to save or catch errors and do nothing
        do {
            try context.save()
        } catch _ {
            
        }
        
        //Get the requests and reload data
        let request = NSFetchRequest(entityName: "Item")
        var results : [AnyObject]?
        
        do{
            results = try context.executeFetchRequest(request)
        } catch _ {
            results = nil
        }
        
        if results != nil {
            self.items = results as! [Item]
        }
    
        self.tableView.reloadData()
        
        
    }
    
    //This handles the popup
    func alertPopup() {
        
        //Creates constants for the alert
        let alert = UIAlertController(title: "Add New Item", message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in alert.dismissViewControllerAnimated(true, completion: nil)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) {
            UIAlertAction in self.saveNewItem()
        }
        
        //Adds items to alert view
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        //Shows the alert
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

