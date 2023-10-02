//
//  TrackModel.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 18.09.2023.
//

import Foundation

class TrackModel: ObservableObject {
    static var shared = TrackModel()
    
    private let dataManager = DataManager()
    @Published private(set) var tracks: [Track] = []
    
    private init() {
        tracks = dataManager.getSavedTracks()
    }
    
    func removeTrack(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        saveTracks()
    }
    
    func appendTrack(_ track: Track) {
        tracks.append(track)
        saveTracks()
    }
    
    private func saveTracks() {
        dataManager.saveTracks(tracks)
    }
}
