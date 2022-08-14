//
//  SettingTableViewController.swift
//  Clipstar
//
//  Created by Oran on 10/07/2022.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingTableViewController: UITableViewController {
    
    var service = Service.shared
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.sectionFooterHeight = 10
        tableView.tableFooterView = UIView()
        getName()
        appVersionLabel.text = "App version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
    }
    
    @IBAction func logOutButtonTapped(_ sender: Any) {
        service.signOut()
    }
    
    @IBAction func tellAFriend(_ sender: Any) {
        let sms: String = "sms:&body=Hello, i want to offer you to download a new app (APPSTOREURL)"
        let strURL: String = sms.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.open(URL.init(string: strURL)!, options: [:], completionHandler: nil)
    }
    
    func getName() {
        
        let db = Firestore.firestore()
        if let userId = Auth.auth().currentUser?.uid {
            
            db.collection("users").getDocuments() { (snapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    
                    if let currentUserDoc = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }),
                       let _ = snapshot?.documents.first(where: { ($0["uid"] as? String) == userId }){
                        
                        let firstName = currentUserDoc["firstName"] as! String
                        let lastName = currentUserDoc["lastName"] as! String
                        print("##### \(firstName)")
                        print("##### \(lastName)")
                        self.nameLabel.text = "\(firstName) \(lastName)"
                        self.emailLabel.text = Auth.auth().currentUser?.email
                        return
                    }
                }
                
                if let user = Auth.auth().currentUser {
                    self.nameLabel.text = user.displayName
                    self.emailLabel.text = user.email
                }
            }
        }
    }
}
