//
//  NewestTableViewController.swift
//  Clipstar
//
//  Created by Oran on 16/07/2022.
//

import UIKit
import YouTubeiOSPlayerHelper


class NewestTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var newestTableView: UITableView!
    
    var service = Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newestTableView.dataSource = self
        newestTableView.delegate = self
        load()
    }
    
    func load() {
        Task{
            _ = await service.getVideos(url: Constants.VideosConstants.API_URL_NEW)
            newestTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.dataArrayNewest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = newestTableView.dequeueReusableCell(withIdentifier: "NewestCell", for: indexPath) as! NewestTableViewCell
        let item = service.dataArrayNewest[indexPath.row]
        cell.videos = item
        cell.loadVideo()
        if (indexPath.row == service.dataArrayNewest.count - 1 ) {
            load()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as? NewestTableViewCell)?.playerView.pauseVideo()
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            (cell as? NewestTableViewCell)?.playerView.playVideo()
        }
    }
}
