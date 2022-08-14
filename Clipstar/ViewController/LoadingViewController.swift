//
//  LoadingViewController.swift
//  Clipstar
//
//  Created by Oran on 06/07/2022.
//

import UIKit
import AVFoundation
import Firebase
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var progress: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progress.setProgress(0.5, animated: false)
        automaticLogin()
    }
    
    @IBAction func button(_ sender: Any) {
        transitionToLoginVC()
    }
    
    func automaticLogin() {
        progress.setProgress(0.8, animated: true)
        
        //MARK: Check Login From Firebase
        if Auth.auth().currentUser != nil {
            print("####### User sign-in from firebase")
            transitionToHomeVC()
        } else {
            transitionToLoginVC()
            print("####### User NOT LOG IN from firebase")
        }
        
        //MARK: Check Login From Facebook
        if (AccessToken.current != nil) {
         
            print("####### User is log-in from facebook")
            transitionToHomeVC()
        } else {
            print("####### User is NOT LOG IN facebook")
        }
        
        //MARK: Check Login From Google
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print("####### User is NOT LOG IN GOOGLE")
                self.transitionToLoginVC()
                
            } else {
                // Show the app's signed-in state.
                print("####### User is sign in from GOOGLE")
                self.transitionToHomeVC()
            }
        }
        progress.setProgress(1.0, animated: true)
    }
    
}


