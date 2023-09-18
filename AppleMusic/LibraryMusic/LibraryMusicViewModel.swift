//
//  LibraryMusicViewModel.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 13.06.2023.
//

import Foundation

class LibraryMusicViewModel {
    
    private let dataManger = DataManager()
    var tracks = [Track]()

    init() {
        tracks = dataManger.getSavedTracks()
    }
    
    func deleteSavedTrack(at offsets: IndexSet) {
        tracks.remove(atOffsets: offsets)
        dataManger.setTracks(tracks)
    }
}
