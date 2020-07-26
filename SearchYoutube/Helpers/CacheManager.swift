//
//  CacheManager.swift
//  MyTubePlay
//
//  Created by Juan Manuel Tome on 22/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation

class CacheManager {
    
    static var cache = [String : Data]()
    
    
    static func setVideoCache(_ url: String, _ data: Data) {
        //Store the image data and use the url as the key
        cache[url] = data
    }
    
    static func getVideoCache(_ url: String) -> Data? {
        //try to get the data for the specified url
        return cache[url]
    }
}
