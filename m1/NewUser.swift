//
//  NewUser.swift
//  m1
//
//  Created by Miaomiao Yu on 29/12/2015.
//  Copyright © 2015 Joseph Silmon-Clyde. All rights reserved.
//

import Foundation
import UIKit


class NewUserViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()

    @IBOutlet weak var userName: UITextField!

    @IBOutlet weak var name: UITextField!

    @IBOutlet weak var passCode: UITextField!
    
    @IBOutlet weak var chooseImageTapped: UIButton!
    
    @IBAction func chooseImageButtonTapped(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            print("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        
       // imageView.image = image
        
    }
    
    @IBAction func createTapped(sender: AnyObject) {

        
        let post:NSString = "userName=\(userName.text!)&name=\(name.text!)&passCode=\(passCode.text!)"
        
        let url:NSURL = NSURL(string:"https://www.bachtobabyserver.com/M1files/CreateAccount.php")!
        
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
                        let alertController = UIAlertController(title: "Account created", message: "You are now a member of M1", preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default) { (_) in
                            self.performSegueWithIdentifier("segueSignUpToLogin", sender: self)
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
    
    
    
    
    
    
    
    
    
    
    
    
}
