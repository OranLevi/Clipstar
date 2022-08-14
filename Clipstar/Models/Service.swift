//
//  Service.swift
//  Clipstar
//
//  Created by Oran on 29/06/2022.
//

import UIKit
import Firebase
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth
import GoogleSignIn


// MARK: - Welcome
struct Welcome: Decodable {
    let items: [Item]
}

// MARK: - Item
struct Item: Decodable {
    let id: ID
}

// MARK: - ID
struct ID: Decodable {
    let videoId: String
}

// MARK: - PageInfo
struct PageInfo: Decodable {
    let totalResults, resultsPerPage: Int
}

class Service: UIViewController {
    
    static let shared: Service = Service()
    
    var dataArrayHome = [Item]()
    var dataArrayMostRating = [Item]()
    var dataArrayNewest = [Item]()
    
    //MARK: - Videos Download
    
    func getVideos(url: String) async -> Welcome? {
        guard let videoURL = URL(string: url) else {
            return nil
        }
        
        let (data, _) = try! await URLSession.shared.data(from: videoURL)
        do {
            let downloadVideo = try JSONDecoder().decode(Welcome.self, from: data)
            if url == Constants.VideosConstants.API_URL_NEW{
                dataArrayNewest.append(contentsOf: downloadVideo.items)
            } else if url == Constants.VideosConstants.API_URL_RATING {
                dataArrayMostRating.append(contentsOf: downloadVideo.items)
            } else {
                dataArrayHome.append(contentsOf: downloadVideo.items)
            }
            return downloadVideo
        } catch (let error) {
            print("error:\(error)")
            return nil
        }
        
    }
    
    
    //MARK: - Transition To Home function - Move to Home VC after SignIn
    
    func transitionToHome(){
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.NameConstants.StoryBoard.homeViewController) as? HomeTableViewController
        
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    //MARK: - ShowError function
    
    static func showError(vc : UIViewController, message: String) ->() {
        let alertView = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            print("Ok button tapped")
        }
        alertView.addAction(alertAction)
        vc.present(alertView, animated: true, completion: nil)
        
    }
    
    //MARK: - SignOut function
    
    func signOut() {
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        alert.addAction(UIAlertAction(title: "Sign out",
                                      style: UIAlertAction.Style.destructive,
                                      handler: {(_: UIAlertAction!) in
            //Logout Facebook
            let logout = LoginManager()
            logout.logOut()
            print("log out facebook")
            
            //Logout Google
            GIDSignIn.sharedInstance.signOut()
            
            //Logout Firebase
            do {
                try Auth.auth().signOut()
                let userDefaults = UserDefaults.standard
                userDefaults.removeObject(forKey: "email")
                userDefaults.removeObject(forKey: "password")
                
            } catch let error {
                print(Service.showError(vc: self, message: error.localizedDescription))
            }
            UIApplication.topViewController()?.transitionToLoginVC()
        }))
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}
