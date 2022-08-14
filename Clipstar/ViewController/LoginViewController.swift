//
//  LoginViewController.swift
//  Clipstar
//
//  Created by Oran on 24/06/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var service = FirebaseManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func FacebookButtonTapped(_ sender: Any) {
        service.facebookLoginIn()
    }
    
    @IBAction func GoogleButtonTapped(_ sender: Any) {
        service.googleLogIn(vc: self)
    }
    
    @IBAction func logInButtonTapped(_ sender: Any) {
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                
                // Couldn't sign in
                Service.showError(vc: self, message: error!.localizedDescription)
            }
            else {
                let userDefaults = UserDefaults.standard
                userDefaults.setValue(self.emailTextField.text!, forKey: "email")
                userDefaults.setValue(self.passwordTextField.text!, forKey: "password")
                self.transitionToHomeVC()
            }
        }
        
    }    
}

