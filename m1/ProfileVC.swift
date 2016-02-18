//
//  ProfileVC.swift
//  m1
//
//  Created by Miaomiao Yu on 10/02/2016.
//  Copyright © 2016 Joseph Silmon-Clyde. All rights reserved.
//

import Foundation
import UIKit



class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var profileId = 0
    let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileId = prefs.integerForKey("PROFILEID") as Int
        
        profileImage.layer.borderWidth = 0.5
        profileImage.layer.cornerRadius = 10
        profileImage.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    @IBAction func loadButtonTapped(sender: AnyObject) {
        
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        profileImage.image = profileImage.image!.resizeToWidth(80.0)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func saveImage(sender: AnyObject) {
        print(myImageUploadRequest())
    }
    
    
    func myImageUploadRequest() -> Int
    {
        

        
        var success = 0
        
        let myUrl = NSURL(string: "https://www.bachtobabyserver.com/M1files/saveImage.php");
        
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "profileId"    : String(profileId)
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(profileImage.image!, 1)
        
        if(imageData==nil)  { return 0 }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
        // myActivityIndicator.startAnimating();
        var responseError: NSError?
        var response: NSURLResponse?
        var urlData: NSData?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            responseError = error
            urlData = nil
        }
        
        // let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        //    urlData, response, error in
        
        /*  if error != nil {
        print("error=\(error)")
        return
        } */
        
        if ( response != nil ) {
            let res = response as! NSHTTPURLResponse!;
            
           
            
            if (res.statusCode >= 200 && res.statusCode < 300)
            {
                let responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                //                     var responseData:NSString  = NSString(data:urlData!, encoding:NSUTF8StringEncoding)!
                
                
                let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
                
                success = jsonData.valueForKey("success") as! NSInteger
                
                
               
                
            }
        }

        
        return success
        
    }
    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "icon"+String(profileId)+".jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }

    
    
    

}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}


extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func resizeToWidth(width:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
