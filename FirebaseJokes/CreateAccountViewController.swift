//
//  CreateAccountViewController.swift
//  FirebaseJokes
//
//  Created by Matthew Maher on 1/23/16.
//  Copyright © 2016 Matt Maher. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        
        if username != "" && email != "" && password != "" {
            
            // set email and password
            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
                
                if error != nil {
                    // there was a problem
                    self.signupErrorAlert("Oops", message: "Having some problems creating your account. Try again")
                } else {
                    // create and login a new user with authUser
                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { err, authData in
                        
                        let user = ["provider": authData.provider!, "email": email!, "username": username!]
                        // seal the deal with DataService
                        DataService.dataService.createNewAccount(authData.uid, user: user)
                    })
                    // store the uid for future use
                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
                    // enter the app
                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
                }
            })
        } else {
            signupErrorAlert("Oops", message: "Don't forget enter your email, password and a username")
            
        
        }
    }
    
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    
    func signupErrorAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(action)
        
        presentViewController(alert, animated: true, completion: nil)
    
    }
    
}
