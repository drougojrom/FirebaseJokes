//
//  LoginViewController.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if we have the uid stored, the user is already logged in - no need to sign up again
        
        if NSUserDefaults.standardUserDefaults().valueForKey("uid") != nil && DataService.dataService.CURRENT_USER_REF.authData != nil {
                self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func tryLogin(sender: AnyObject) {
        
        let email = emailField.text
        let password = passwordField.text
        
        if email != "" && password != "" {
            // login with firebase login
            
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { error, authData in
                
                if error != nil {
                    print(error)
                    self.loginErrorAlert("Oops", message: "Check your username and password")
                } else {
                    // be sure the correct uid is stored
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
                    
                    // enter the app
                    self.performSegueWithIdentifier("CurrentlyLoggedIn", sender: nil)
                    
                }
            })
        } else {
            // there is a problem
            loginErrorAlert("Oops", message: "Don't forget to enter your email and password")
        }
        
    }
    
    func loginErrorAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
