//
//  NetworkService.swift
//  IMusic
//
//  Created by macbook on 27.06.2023.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTrack(searchText: String, complition: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let paramets = ["term": "\(searchText)",
                        "country" : "RU",
                        "limit" : "15",
                        "media" : "music"]
        
        AF.request(url, method: .get, parameters: paramets, encoding: URLEncoding.default, headers: nil).responseData { dataResponsce in
            if let error = dataResponsce.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                complition(nil)
                return
            }
            
            guard let data = dataResponsce.data else { return }
            
            let decoder = JSONDecoder()
            do {
                let object = try decoder.decode(SearchResponse.self, from: data)
                print("objects: ", object)
                complition(object)
                
            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                complition(nil)
            }
        }
    }
}
