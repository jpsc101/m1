//
//  LoginViewController.swift
//  m1
//
//  Created by Miaomiao Yu on 26/12/2015.
//  Copyright © 2015 Joseph Silmon-Clyde. All rights reserved.
//

import Foundation
import UIKit

var profiles = ["Mercutio":"nunchuks","Aubrey":"cannon"]

class LoginViewController: UIViewController {
    
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passCode: UITextField!

    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        print("Hello")
        print("hello twice")
        
       // if(profiles[userName.text!] == passCode.text!) {
        
        let post:NSString = "userName=\(userName.text!)&passCode=\(passCode.text!)"
        print(post)
        
        let url:NSURL = NSURL(string:"https://www.bachtobabyserver.com/M1files/login.php")!
        
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
            
            print(res)
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                
                let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                
                let success:NSInteger = jsonData.valueForKey("success") as! NSInteger
                
                
                print(jsonData)
                
                if(success == 1)
                {
                    let profileId:NSInteger = jsonData.valueForKey("profileId") as! NSInteger
                    prefs.setInteger(profileId, forKey: "PROFILEID")
                    self.performSegueWithIdentifier("segueLoginToMain", sender: self)
                    
                } else {
                    var error_msg:NSString
                    
                    if jsonData["error_message"] as? NSString != nil {
                        error_msg = jsonData["error_message"] as! NSString
                    } else {
                        error_msg = "Unknown Error"
                    }
                    let alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign in Failed!"
                    alertView.message = error_msg as String
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                    
                }
                
            } else {
                let alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failed"
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            }
        } else {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Connection Failure"
            if let error = responseError {
                alertView.message = (error.localizedDescription)
            }
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "segueLoginToMain"
        {
            if let destinationVC = segue.destinationViewController as? ViewController{
                destinationVC.userName = userName.text!
                
            }
        }
    }




}





