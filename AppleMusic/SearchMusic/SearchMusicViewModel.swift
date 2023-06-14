//
//  SearchMusicViewModel.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 13.06.2023.
//

import Foundation

class SearchMusicViewModel {
    
    private var tracks = [Track]()
    private let networkService = NetworkService()
    
    func numberOfRows() -> Int {
        tracks.count
    }
    
    func getTrack(indexPath: IndexPath) -> Track {
        tracks[indexPath.row]
    }
    
    func fetchTracks(searchText: String, complection: @escaping () -> ()) {
        Task {
            let result = try await networkService.getTracks(searchText: searchText)
            tracks = result.results
            complection()
        }
    }
    
}
