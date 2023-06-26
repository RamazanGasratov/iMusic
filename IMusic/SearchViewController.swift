//
//  SearchViewController.swift
//  IMusic
//
//  Created by macbook on 22.06.2023.
//

import UIKit
import Alamofire

struct TrackModel {
    var trackName: String
    var artistName: String
}

class SearchViewController: UITableViewController {
    
    private var timer = Timer()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var tracks = [Track]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSearchBar()
    
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    private func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let track = tracks[indexPath.row]
        cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
        cell.textLabel?.numberOfLines = 2
        
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      //  print(searchText)
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            let url = "https://itunes.apple.com/search"
            let paramets = ["term": "\(searchText)",
                            "country" : "RU",
                            "limit" : "15"]
            
            AF.request(url, method: .get, parameters: paramets, encoding: URLEncoding.default, headers: nil).responseData { dataResponsce in
                if let error = dataResponsce.error {
                    print("Error received requestiong data: \(error.localizedDescription)")
                    return
                }
                
                guard let data = dataResponsce.data else { return }
                
                let decoder = JSONDecoder()
                do {
                    let object = try decoder.decode(SearchResponse.self, from: data)
                    print("objects: ", object)
                    self.tracks = object.results
                    self.tableView.reloadData()
                    
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
                
            }
        })
    }
}
