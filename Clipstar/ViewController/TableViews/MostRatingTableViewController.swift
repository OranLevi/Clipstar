//
//  MostRatingTableViewController.swift
//  Clipstar
//
//  Created by Oran on 16/07/2022.
//

import UIKit
import YouTubeiOSPlayerHelper

class MostRatingTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var mostTableView: UITableView!
    
    var service = Service.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mostTableView.dataSource = self
        mostTableView.delegate = self
        load()
    }
    
    func load() {
        Task{
            _ = await service.getVideos(url: Constants.VideosConstants.API_URL_RATING)
            mostTableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.dataArrayMostRating.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mostTableView.dequeueReusableCell(withIdentifier: "MostRatingCell", for: indexPath) as! MostRatingTableViewCell
        let item = service.dataArrayMostRating[indexPath.row]
        cell.videos = item
        cell.loadVideo()
        if (indexPath.row == service.dataArrayMostRating.count - 1 ) {
            load()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.size.height
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("############ Playing Stopped:")
        (cell as? MostRatingTableViewCell)?.playerView.pauseVideo()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
            (cell as? MostRatingTableViewCell)?.playerView.playVideo()
        }
    }
}
