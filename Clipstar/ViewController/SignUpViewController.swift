//
//  SignUpViewController.swift
//  Clipstar
//
//  Created by Oran on 24/06/2022.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseCore
import SwiftUI

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var service = FirebaseManager.shared
    var serviceLoginManager = FirebaseManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 20
    }
    
    func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func validDataFields() -> String? {
        // Check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields."
        }
        
        // Check if the password is secure
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(cleanedPassword) == false {
            // Password isn't secure enough
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate the fields
        let error = validDataFields()
        if error != nil {
            // There's something wrong with the fields, show error message
            Service.showError(vc: self, message: error!)
        }
        else {
            // Create cleaned versions of the data
            let fireName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Create the user
            Auth.auth().createUser(withEmail: email, password: password) { resulte, err in
                // Check for errors
                if err != nil {
                    // There was an error creating the user
                    Service.showError(vc: self, message: "Error creating user \n make sure you enter: \n current email")
                }
                else {
                    // User was created successfully
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":fireName,"lastName":lastName,"email":email, "uid": resulte!.user.uid]) { error in
                        if error != nil {
                            // Show error message
                            Service.showError(vc: self, message: " Error saving user Data")
                        }
                    }
                    self.transitionToHomeVC()
                }
            }
        }
    }
    
    @IBAction func facebookButtonTapped(_ sender: UIButton) {
        serviceLoginManager.facebookLoginIn()
    }
    
    @IBAction func googleButtonTapped(_ sender: Any) {
        serviceLoginManager.googleLogIn(vc: self)
    }
}





