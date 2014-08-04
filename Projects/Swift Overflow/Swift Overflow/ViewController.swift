//
//  ViewController.swift
//  Swift Overflow
//
//  Created by John Clem on 7/28/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let networkController = NetworkController()
    let imageQueue = NSOperationQueue()
    
    var questions = Array<NSDictionary>()
    var document : UIManagedDocument!
    var context : NSManagedObjectContext?
    
    @IBOutlet var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupManagedDocumentWithCompletion() {
            (success) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func setupManagedDocumentWithCompletion(completionHandler: ((Bool, context : NSManagedObjectContext) -> Void) ) {
        self.document = UIManagedDocument(fileURL: self.documentFileURL())
        self.document.persistentStoreOptions = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        
        if !NSFileManager.defaultManager().fileExistsAtPath(self.documentFileURL().path) {
            // document does not exist, we need to create it
            self.document.saveToURL(self.documentFileURL(), forSaveOperation: UIDocumentSaveOperation.ForCreating) {
                (success) in
                completionHandler(success, context: self.document.managedObjectContext)
            }
        } else {
            switch self.document.documentState {
            case UIDocumentState.Closed:
                // document is close, we need to open it
                self.document.openWithCompletionHandler() {
                    (success) in
                    completionHandler(success, context: self.document.managedObjectContext)
                }
            default:
                // document is open, just return it
                completionHandler(true, context: self.document.managedObjectContext)
            }
            
        }
    }
    
    func documentFileURL() -> NSURL {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentDirectory = paths[0] as String
        return NSURL(fileURLWithPath: documentDirectory.stringByAppendingPathComponent("SwiftOverflow.document"))
    }
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        let question = questions[indexPath.row]
        
        cell.textLabel.text = question["title"] as? String
        
        if let cellImage : UIImage = cell.imageView.image {
            
        } else {
            imageQueue.addOperationWithBlock() {
                let imageData = NSData(contentsOfURL: NSURL(string: "http://critterbabies.com/wp-content/gallery/kittens/803864926_1375572583.jpg"))
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    cell.imageView.image = UIImage(data: imageData)
                    self.updateCellForRow(indexPath.row)
                }
            }
        }
        
        return cell
    }
    
    func updateCellForRow(row : Int) {
        self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let question = questions[tableView.indexPathForSelectedRow().row]
        let questionURL = question["link"] as? String
        let webView = UIWebView(frame: self.view.bounds)
        let webViewController = UIViewController()
        webViewController.view.bounds = self.view.bounds
        webViewController.view.addSubview(webView)

        let request = NSURLRequest(URL: NSURL(string: questionURL))
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        webView.loadRequest(request)
        
        self.navigationController.pushViewController(webViewController, animated: true)
    }
    
    //MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        let searchTerm = searchBar.text
        searchBar.resignFirstResponder()
        let rawQuestions = networkController.searchResultsForQueryString(searchTerm)
        for rawQuestion in rawQuestions {
            if let entityDescription = NSEntityDescription.entityForName("Question", inManagedObjectContext: self.context) {
                let question = Question(entity: entityDescription, insertIntoManagedObjectContext: self.context)
                question.answer_count = rawQuestion["answer_count"] as NSNumber
                question.creation_date = rawQuestion["creation_date"] as NSDate
                question.is_answered = rawQuestion["is_answered"] as NSNumber
                question.link = rawQuestion["link"] as String
                question.title = rawQuestion["title"] as String
                
                var err : NSError?
                self.context?.save(&err)
                if !err {
                    tableView?.reloadData()
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        questions.removeAll(keepCapacity: false)
        tableView?.reloadData()
    }
}

