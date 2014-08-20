//
//  ViewController.swift
//  CoreDataMusic
//
//  Created by Bradley Johnson on 8/19/14.
//  Copyright (c) 2014 learnswift. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var myContext : NSManagedObjectContext!
    var fetchedResultsController : NSFetchedResultsController!
                            
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get the MoC from app delegate
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.myContext = appDelegate.managedObjectContext
        
        // setup the fetched results controller
        var request = NSFetchRequest(entityName: "Label")
        let sort = NSSortDescriptor(key: "name", ascending: true)
        
        // add sort to the request
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 20
        
        // initialize the fetched results controller
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.myContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // perform fetch on appearance
        var error : NSError?
        fetchedResultsController.performFetch(&error)
        if error != nil {
            println("Error fetching labels: \(error?.localizedDescription)")
        }
    }

    @IBAction func addLabelPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("addLabel", sender: self)
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController!.sections[section].numberOfObjects
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as UITableViewCell
        self.configureCell(cell, forIndexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        var label = self.fetchedResultsController.fetchedObjects[indexPath.row] as Label
        cell.textLabel.text = label.name
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "ShowArtists" {
            let artistsVC = segue.destinationViewController as ArtistsViewController
            var label = self.fetchedResultsController.fetchedObjects[self.tableView.indexPathForSelectedRow().row] as Label
            artistsVC.selectedLabel = label
        }
    }
    
    
    //MARK: NSFetchedResultsControllerDelegate Methods
    
    
    // called when an object is about to change
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.beginUpdates()
    }
    
    // called after a change is committed
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController!, didChangeObject anObject: AnyObject!, atIndexPath indexPath: NSIndexPath!, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath!) {
        switch type {
        case .Insert:
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath), forIndexPath: indexPath)
        case .Move:
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
        }
    }
    
    //MARK: TableView Delete Rows
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        // don't need anything here, just have to implement it for the respondsToSelector: test
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
        // create a delete action
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") {
            (action, indexPath) in
            // implement the delete changes
            if let labelForRow = self.fetchedResultsController.fetchedObjects[indexPath.row] as? Label {
                self.myContext.deleteObject(labelForRow)
                self.myContext.save(nil)
            }
        }
        
        let moreAction = UITableViewRowAction(style: .Default, title: "More") { (action, indexPath) -> Void in
            println("More Action Tapped")
        }
        
        // set the background color for the action button
        deleteAction.backgroundColor = UIColor.redColor()
        moreAction.backgroundColor = UIColor.lightGrayColor()
        
        // return an array of actions
        return [deleteAction, moreAction]
    }
    
}
















