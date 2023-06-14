//
//  TrackCellViewModel.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import Foundation

class TrackCellViewModel: TrackCellViewModelProtocol {
    
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
    
}
