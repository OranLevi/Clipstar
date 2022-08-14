//
//  HomeTableViewCell.swift
//  Clipstar
//
//  Created by Oran on 16/07/2022.
//

import UIKit
import Firebase
import YouTubeiOSPlayerHelper

class HomeTableViewCell: UITableViewCell, YTPlayerViewDelegate  {

    var videos: Item?
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.delegate = self
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func loadVideos(){
        let playerVars = ["modestbranding": 1, "controls" : 0, "loop" : 1, "fs" : 0,] as [String : Any]
        playerView.load(withVideoId:  videos!.id.videoId , playerVars: playerVars)
    }
}
