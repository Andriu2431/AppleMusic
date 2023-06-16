//
//  TrackDetailViewModel.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 15.06.2023.
//

import Foundation

class TrackDetailViewModel: TrackDetailViewModelProtocol {
    
    private let track: Track
    
    init(track: Track) {
        self.track = track
    }
    
    var trackName: String {
        track.trackName
    }
    
    var artistName: String {
        track.artistName
    }
    
    var collectionName: String {
        track.collectionName
    }
    
    var artworkUrl100: String? {
        track.artworkUrl100
    }
    
    var previewUrl: String? {
        track.previewUrl
    }
}
