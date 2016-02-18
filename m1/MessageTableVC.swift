//
//  MessageTableVC.swift
//  m1
//
//  Created by Miaomiao Yu on 05/02/2016.
//  Copyright © 2016 Joseph Silmon-Clyde. All rights reserved.
//




import Foundation
import UIKit

class MessageTableVC: UITableViewController, UpdateMessageTableDelegate      {
    
    var messages = NSMutableArray()
    
    
    
    // Delegate method: B5
    func refreshMessageTableVC(controller: ViewController) {
        downloadMessages()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        
        downloadMessages()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        // Delegate method: B4
        let VCP = parentViewController as! ViewController
        VCP.delegate = self
        
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.downloadMessages()
        refreshControl.endRefreshing()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return  messages.count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> messageCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! messageCell
        

        
        cell.userName.text = messages[(indexPath.row)].valueForKey("userName")as! String
        
        cell.message.text = messages[(indexPath.row)].valueForKey("message")as! String
        
        
        
        return cell
    }
    
    func downloadMessages() {
 
        let post:NSString = "password=cdfgectvfgfgsdvw"
        
        let url:NSURL = NSURL(string:"https://www.bachtobabyserver.com/M1files/MessagesDownload.php")!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, urlData, responseError) -> Void in
            
            if ( urlData != nil ) {
                let res = response as! NSHTTPURLResponse!;
                
                
                if (res.statusCode >= 200 && res.statusCode < 300)
                {
                    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                    
                    let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                    
                    if (success == 1) {
                        let messagesTemp = jsonData["messages"] as! NSArray
                        self.messages = NSMutableArray()
                        for message in messagesTemp {

                                self.messages.addObject(message)
                            }
                        }
                    
                        self.tableView.reloadData()
                }
            }

        })
    }
    
    
    
}

