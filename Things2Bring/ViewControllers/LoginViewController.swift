//
//  LoginViewController.swift
//  Things2Bring
//
//  Created by Jessica Cavazos on 7/22/15.
//  Copyright (c) 2015 Jessica Cavazos. All rights reserved.
//

import UIKit
import Parse
import Realm
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var invitationlink = false
    var eventId:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

    @IBAction func Login(sender: AnyObject) {
        var username = usernameTextField.text
        var password = passwordTextField.text
        PFUser.logInWithUsernameInBackground(username, password: password) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.segue()
            } else {
                self.usernameTextField.text = "No user Found"
            }
        }
    }
    
    func segue(){
        if !invitationlink{
            performSegueWithIdentifier("LoggedIn", sender: self)
        } else {
            performSegueWithIdentifier("ShowEvent", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowEvent"{
            var navcontroller = segue.destinationViewController as! UINavigationController
            var EventController = navcontroller.topViewController as! EventViewController
            EventController.openbylink = true
            EventController.eventId = eventId!
        } else if segue.identifier == "SignUp"{
            var SignUpController = segue.destinationViewController as! SignUpViewController
            SignUpController.invitationLink = invitationlink
            SignUpController.eventId = eventId
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
