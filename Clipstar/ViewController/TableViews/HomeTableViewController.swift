//
//  HomeTableViewController.swift
//  Clipstar
//
//  Created by Oran on 16/07/2022.
//

import UIKit
import Firebase
import YouTubeiOSPlayerHelper

class HomeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var service = Service.shared
    var cell = HomeTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        load()
    }
    
    func load() {
        Task {
            _ = await service.getVideos(url: Constants.VideosConstants.API_URL)
            homeTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        service.dataArrayHome.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTableViewCell
        let item = service.dataArrayHome[indexPath.row]
        cell.videos = item
        cell.loadVideos()
        if (indexPath.row == service.dataArrayHome.count - 1 ) {
            load()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? HomeTableViewCell)?.playerView.pauseVideo()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            (cell as? HomeTableViewCell)?.playerView.playVideo()
        }
    }
}

