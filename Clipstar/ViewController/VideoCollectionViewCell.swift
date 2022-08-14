//
//  VideoCollectionViewCell.swift
//  MyProject
//
//  Created by test5 on 10/07/2022.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoCollectionViewCell: UICollectionViewCell, YTPlayerViewDelegate {

    var videos: Item?
    @IBOutlet var playerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        playerView.delegate = self
        // Initialization code
        }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

    func loadVideos(){
        let playerVars = ["modestbranding": 1, "controls" : 0, "loop" : 1, "fs" : 0,] as [String : Any]
        playerView.load(withVideoId:  videos!.id.videoId , playerVars: playerVars)
    }
}

