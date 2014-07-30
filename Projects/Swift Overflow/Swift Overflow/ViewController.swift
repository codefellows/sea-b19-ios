//
//  ViewController.swift
//  Swift Overflow
//
//  Created by John Clem on 7/28/14.
//  Copyright (c) 2014 Learn Swift. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let networkController = NetworkController()
    var questions = Array<NSDictionary>()
    let imageQueue = NSOperationQueue()
    
    @IBOutlet var tableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        imageQueue.maxConcurrentOperationCount = 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        questions = networkController.searchResultsForQueryString(searchTerm)
        tableView?.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        questions.removeAll(keepCapacity: false)
        tableView?.reloadData()
    }
}

