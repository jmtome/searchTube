//
//  Response.swift
//  MyTubePlay
//
//  Created by Juan Manuel Tome on 21/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation


//we must now instruct our decodable protocols how to decode the big chunk of JSON object first received which contains "items" as a key.

struct Response: Decodable {
    var items: [Video]?
    
    enum CodingKeys: String, CodingKey {
        
        //actually since the key matches the JSON object from the youtube api we wouldnt need to do the = "items", but ill just do it
        
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        
        // we first get the container
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //this gives us the big container JSON object which has the subkeys like "kind", "etag", "nextPageToken" and the one we want "items" (and also "pageInfo")
        self.items = try container.decode([Video].self, forKey: .items)
        //here we are assigning the "items" JSON object, which is essentially an array of Video.self, which we decoded previously inside the file Video.swift
//        print(self.items)
        //we now go back to the model
        //https://youtu.be/HEGDUm-6FR0?t=1887
        
    }
    
}
