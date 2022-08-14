//
//  Constans.swift
//  Clipstar
//
//  Created by Oran on 24/06/2022.
//
/*
 
 All the keys are hidden, if you have key please uncomment the code and put you keys below.

 also the GoogleService.plist and (info.plist) URL Types is hidden.

 you need also type the Google ID and Facebook ID
 also in the info file.

 
 ////////////////////////////////////////////////
 ** WITHOUT THE KEYS AND GoogleService.plist THE APP WILL BE NOT WORKING!
 ///////////////////////////////////////////////
 
 For any question/problem feel free to contact me.
 */

import UIKit


class Constants {
    
    var googleClientID = "" // ENTER GOOGLE CLIENT ID
    
    struct NameConstants {
        struct StoryBoard {
           static let homeViewController = "HomeVC"
            static let LoginScreen = "LoginScreen"
        }
    }

    struct VideosConstants {
        
        static var API_KEY = "" // ENTER YOUR YOUTUBE API KEY
        static var API_URL = "https://youtube.googleapis.com/youtube/v3/search?q=%23shorts&key=\(API_KEY)"
        static var API_URL_RATING = "https://youtube.googleapis.com/youtube/v3/search?order=rating&q=%23shorts&key=\(API_KEY)"
        static var API_URL_NEW = "https://youtube.googleapis.com/youtube/v3/search?order=date&q=%23shorts&key=\(API_KEY)"
        static var TY_EMBED_URL = "https://www.youtube.com/embed/"
    }
    
}

