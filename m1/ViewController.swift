//
//  ViewController.swift
//  m1
//
//  Created by Miaomiao Yu on 21/12/2015.
//  Copyright © 2015 Joseph Silmon-Clyde. All rights reserved.
//

import UIKit
import AVFoundation

// Delegate method: B1
protocol UpdateMessageTableDelegate {
    func refreshMessageTableVC(controller:ViewController)
}

class ViewController: UIViewController {
    
    var delegate: UpdateMessageTableDelegate?
    var userName = ""

    @IBOutlet weak var userNameText: UILabel!
    @IBOutlet weak var messageTextField: UITextField!

    
    
    
    @IBAction func showButtonPressed(sender: AnyObject) {
        
        if(messageTextField.text != "") {
        
        let post:NSString = "userName=\(userName)&message=\(messageTextField.text!)"
        
        let url:NSURL = NSURL(string:"https://www.bachtobabyserver.com/M1files/SaveMessage.php")!
        
        let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        
        let postLength:NSString = String( postData.length )
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        var responseError: NSError?
        var response: NSURLResponse?
        
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            responseError = error
            urlData = nil
        }
        
        if ( urlData != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                
                let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                
                
                
                
                if(success == 1)
                {
                    let alertController = UIAlertController(title: "Message sent", message: "", preferredStyle: .Alert)
                    let okAction = UIAlertAction(title: "OK", style: .Default) { (_) in

                    }
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                } else {
                    
                    var error_msg:NSString
                    
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Account creation failed"
                    alertView.message = error_msg as String
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                    
                }
                
            } else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Account creation failed"
                alertView.message = "Connection Failed"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Account creation failed"
            alertView.message = "Connection Failure"
            if let error = responseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
        }

        // Delegate method: B3
        if let delegate = self.delegate {
            delegate.refreshMessageTableVC(self)
        }
        
        messageTextField.text = ""
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.text = "User: "+userName
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

