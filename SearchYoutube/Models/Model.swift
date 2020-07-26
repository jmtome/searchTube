//
//  Model.swift
//  MyTubePlay
//
//  Created by Juan Manuel Tome on 18/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import Foundation

protocol ModelDelegate {
    func videosFetched(_ videos: [Video])
}

class Model {
    
    var delegate: ModelDelegate?
    
    func getVideos(with query: String?) {
                
        let searchQuery = query ?? "mkbhd"
        
        let urlString = Constants.makeURL(with: searchQuery)
        
        // Create a URL Object
        guard let url = URL(string: urlString) else { return }
        // Get a URL Session Object
        print(url)
        let session = URLSession.shared
        // Get a Data Task
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else { return }
            
            
            // parsing the data into video objects
            let decoder = JSONDecoder()
            //we need to specify the date decoding strategy, the date format
            decoder.dateDecodingStrategy = .iso8601 //standard format
            
            //so now, we try to decode the JSON object returned from the API call to youtube which we called Response
            do {
                let response = try decoder.decode(Response.self, from: data)
                
                if let videos = response.items {
                    // Call the "videosFetched" method of the delegate
                    DispatchQueue.main.async {
                        self.delegate?.videosFetched(videos)
                    }
                    dump(response)
                }
                
                
            } catch {
                
            }
        }
        // Kick off the task
        dataTask.resume()
    }
}
