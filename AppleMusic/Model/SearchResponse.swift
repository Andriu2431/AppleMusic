//
//  SearchResponse.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 12.06.2023.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Codable, Identifiable {
    let id = UUID()
    var trackName: String
    var artistName: String
    var collectionName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
