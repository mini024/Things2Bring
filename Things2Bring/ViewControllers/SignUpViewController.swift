//
//  SignUpViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/24/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse
import Realm
import RealmSwift

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var eventId:AnyObject?
    var invitationLink = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Signup(sender: AnyObject) {
        var user = PFUser()
        user.username = usernameTextField.text
        user["Name"] = nameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        // other fields can be set just like with PFObject
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                var alert = UIAlertView(title: "Error", message: "BLa", delegate: self, cancelButtonTitle: "Ok")
                    alert.show()
            } else {
                PFUser.logInWithUsernameInBackground(user.username!, password:user.password!) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        self.segue()
                    } else {
                        println(error)
                    }
                }
            }
        }
    }
    
    func segue(){
        if !invitationLink{
            performSegueWithIdentifier("Events", sender: self)
        } else {
            performSegueWithIdentifier("ShowInvEvent", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowInvEvent"{
            var navcontroller = segue.destinationViewController as! UINavigationController
            var EventController = navcontroller.topViewController as! EventViewController
            EventController.openbylink = true
            EventController.eventId = eventId! as! String
        }
    }

}
