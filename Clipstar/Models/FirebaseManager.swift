//
//  FirebaseManager.swift
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

class FirebaseManager: UIViewController {
    
    static let shared: FirebaseManager = FirebaseManager()
    var service = Service.shared
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Facebook Login function
    
    func facebookLoginIn(){
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                }else {
                    UIApplication.topViewController()?.transitionToHomeVC()
                }
            })
        }
    }
    
    //MARK: - Google Login function
    func googleLogIn(vc: UIViewController){
        
        let signInConfig = GIDConfiguration(clientID: Constants().googleClientID)
        GIDSignIn.sharedInstance.signIn(
            with: signInConfig,
            presenting: vc) { user, error in
                guard user != nil else {
                    // Inspect error
                    return
                }
                
                guard let auth = user?.authentication else {return}
                let credentails = GoogleAuthProvider.credential(withIDToken: auth.idToken!, accessToken: auth.accessToken)
                Auth.auth().signIn(with: credentails) { (authResult, error) in
                    if let error = error{
                        print("error because \(error)")
                        return
                    }
                    print("successful sign in ")
                    UIApplication.topViewController()?.transitionToHomeVC()
                    
                }
                
            }
    }
}

extension UIViewController {
    
    func transitionToHomeVC() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.NameConstants.StoryBoard.homeViewController) as? UITabBarController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
        
    }
    
    func transitionToLoginVC() {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.NameConstants.StoryBoard.LoginScreen) as? LoginViewController
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
    }
}
