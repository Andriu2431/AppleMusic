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
    private let dataManager = DataManager()
    private let trackModel = TrackModel.shared
    
    func numberOfRows() -> Int {
        tracks.count
    }
    
    func fetchTracks(searchText: String, complection: @escaping () -> ()) {
        Task {
            let result = try await networkService.getTracks(searchText: searchText)
            tracks = result.results
            complection()
        }
    }
    
    func configureTrackCellViewModel(indexPath: IndexPath) -> TrackCellViewModelProtocol {
        TrackCellViewModel(track: tracks[indexPath.row])
    }
    
    func configureTrackDetailViewModel(indexPath: IndexPath) -> TrackDetailViewModelProtocol {
        TrackDetailViewModel(track: tracks[indexPath.row])
    }
    
    func appendTrackToTrackModel(_ indexPath: IndexPath) {
        let track = tracks[indexPath.row]
        trackModel.appendTrack(track)
    }
    
    func getSavedTracks() -> [Track] {
        dataManager.getSavedTracks()
    }
}
