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
    
}
