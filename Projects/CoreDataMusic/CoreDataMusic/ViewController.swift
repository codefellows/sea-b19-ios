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
    var labels = [Label]()
                            
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController : NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.myContext = appDelegate.managedObjectContext
        
        self.setupFetchedResultsController()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var error : NSError?
        fetchedResultsController?.performFetch(&error)
        if error != nil {
            println(error?.localizedDescription)
        }
    }
    
    func setupFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: "Label")
        let sort = NSSortDescriptor(key: "name", ascending: false)
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchBatchSize = 25
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.myContext, sectionNameKeyPath: nil, cacheName: "Root")
        self.fetchedResultsController.delegate = self
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
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if segue.identifier == "addLabel" {
            let addLabelVC = segue.destinationViewController as AddLabelViewController
        } else if segue.identifier == "ShowArtists" {
            let artistsVC = segue.destinationViewController as ArtistsViewController
            var labelForRow = self.fetchedResultsController.fetchedObjects[self.tableView.indexPathForSelectedRow().row] as Label
            artistsVC.selectedLabel = labelForRow
        }
    }
    
    //MARK: NSFetchedResultsControllerDelegate Methods
    
    func controllerWillChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.beginUpdates()
    }

    func controller(controller: NSFetchedResultsController!, didChangeSection sectionInfo: NSFetchedResultsSectionInfo!, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            self.tableView.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        }
    }
    
    func configureCell(cell: UITableViewCell, forIndexPath indexPath: NSIndexPath) {
        var labelForRow = self.fetchedResultsController.fetchedObjects[indexPath.row] as Label
        cell.textLabel.text = labelForRow.name
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
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        self.tableView.endUpdates()
    }
    
    //MARK: Table View Re-Ordering
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        // don't need anything here, just have to implement it for the respondsToSelector test
    }
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
            println("Delete Action")
            
            
            var labelForRow = self.fetchedResultsController.fetchedObjects[indexPath.row] as Label
            self.myContext.deleteObject(labelForRow)
        }
        deleteAction.backgroundColor = UIColor.redColor()
        
//        let editAction = UITableViewRowAction(style: .Default, title: "Edit") { (action, indexPath) -> Void in
//            println("Edit Action")
//            let cell = tableView.cellForRowAtIndexPath(indexPath) as UITableViewCell
//            
//        }
//        editAction.backgroundColor = UIColor.lightGrayColor()

        return [deleteAction]
    }
}

