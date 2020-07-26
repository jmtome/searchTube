//
//  ViewController.swift
//  SearchYoutube
//
//  Created by Juan Manuel Tome on 23/07/2020.
//  Copyright © 2020 Juan Manuel Tome. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text {
            //self.model.getVideos(with: text)
            //self.searchQuery = text
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.placeholder = searchBar.text
        searchController.isActive = false
        model.getVideos(with: searchBar.placeholder)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.text = searchController.searchBar.placeholder
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        print("pepe")
    }
    var videos: [Video] = [Video]()
    var model = Model()
    var searchController: UISearchController! = UISearchController(searchResultsController: nil)
    //var searchQuery: String = ""
    var tableView: UITableView! = {
        let tableView = UITableView(frame: .zero)
        tableView.register(VideoTableViewCell.self, forCellReuseIdentifier: Constants.VIDEOCELL_ID)
        return tableView
    }()
    override func loadView() {
        super.loadView()
        view = tableView
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true 
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        model.delegate = self
        model.getVideos(with: nil)
    }


}
extension ViewController: ModelDelegate {
    func videosFetched(_ videos: [Video]) {
        self.videos = videos
        
        self.tableView.reloadData()
    }
    
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.VIDEOCELL_ID, for: indexPath) as! VideoTableViewCell
        let video = videos[indexPath.row]
        cell.setCell(video)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)

        // get a reference to the video that was tapped on
        let video = videos[indexPath.row]
        
        //get a reference to the detail view controller
        let vc = DetailViewController()
        //set the video property of the detail view controller
        vc.view.backgroundColor = .red
        vc.video = video
        modalPresentationStyle = .automatic
        self.present(vc, animated: true, completion: nil)
    }
    
}
