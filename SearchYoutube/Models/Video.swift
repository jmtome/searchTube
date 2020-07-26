//
//  Video.swift
//  MyTubePlay
//
//  Created by Juan Manuel Tome on 18/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation

struct Video: Decodable {
    
    var videoID: String = ""
    var title: String = ""
    var description: String = ""
    var thumbnail: String = ""
    var published: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        
        //since there is a hierarchy to follow, we have to specify the items
        case snippet = "snippet" //includes the cases of published, title, description, it also includes "thumbnails"
        //which we need to obtain the url,
        // to follow an order i will put the cases in hierarchical order, snippet->subs->subsOfSubs
        case published = "publishedAt"
        case title = "title"
        // if it matches i dont have to specify the string value and It could be left like
        //case title
        //case description
        //case videoId
        case description = "description"
        case thumbnails = "thumbnails"
        case high = "high" //high is a subJson of thumbnails
        case thumbnail = "url" // url is a subjson entry of high, which we will call thumbnail and not url
        
        case resourceId = "resourceId"
        case id = "id"
        case channelId
        case videoId = "videoId" // videoId is a subJSON of resourceId
        
    }
    
    init(from decoder: Decoder) throws {
     
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //this constant called "container" will symbolize the json object that is keyed by the key "items" in the youtube json
        let snippetContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .snippet)
        // so now, we need our snippet JSON object, keyed by "snippet", this object lies inside our "container" (the "container" object that simbolized "items"),
        
        //parse title
        self.title = try snippetContainer.decode(String.self, forKey: .title)
        //parse description
        print(self.title)
        self.description = try snippetContainer.decode(String.self, forKey: .description)
        print(self.description)
        //parse the published date
        self.published = try snippetContainer.decode(Date.self, forKey: .published)
        print(self.published)
        //parse thumbnails
        let thumbnailContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnails)
        
        //we parse the "high" json object, nested from "thumbnails"
        let highContainer = try thumbnailContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .high)
        
        //finally we have access to the "url"
        self.thumbnail = try highContainer.decode(String.self, forKey: .thumbnail)
        print(self.thumbnail)
        //now we have to parse the videoID, which is nested from the "resourceId"
        //let resourceContainer = try snippetContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .resourceId)
        
        do {
            let resourceContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .id)
            self.videoID = try resourceContainer.decode(String.self, forKey: .videoId)
            print(self.videoID)
        } catch let error {
            print(error)
        }
        
        
//        if let videoIDContainer = resourceContainer {
//            self.videoID = try videoIDContainer.decode(String.self, forKey: .videoId)
//        } else {
//            if let channelIDContainer = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .channelId) {
//                self.videoID = try channelIDContainer.decode(String.self, forKey: .videoId)
//            }
//
//        }
        
        
        
        
    }
    
}



//containers are JSON objects, each JSON object starts and finishes with { }, JSON objects may contain other containers( json objects )
//example,
/*
 {
    "items": [{
            <this is a JSON object, which is a container>
            "snippet": {
                    <the value of the snippet key this is also a json object, which is also a container>
                    "thumbnails": {
                        <the value of thumbnails is also a json object, which is also a container>
                        "default": {
                                <this is also a json object which is also a container>
                                
                        }
                    }
            }
        }
        ,{
            <also a container>
        }
    ]
 }
 */
