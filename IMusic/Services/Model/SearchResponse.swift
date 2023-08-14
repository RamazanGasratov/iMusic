//
//  SearchResponse.swift
//  IMusic
//
//  Created by macbook on 26.06.2023.
//

import Foundation
struct SearchResponse: Decodable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Decodable {
    var trackName: String
    let collectionName: String?
    let artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
