//
//  DataManager.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 07.09.2023.
//

import Foundation

class DataManager {
    
    static let favouriteTrackKey = "favouriteTrackKey"
    let defaults = UserDefaults.standard
    
    func set(_ track: Track) {
        var listOfTracks = [Track]()
        listOfTracks = getSavedTracks()
        if !listOfTracks.contains(where: { $0.previewUrl == track.previewUrl }) {
            listOfTracks.append(track)
        }
        
        do {
            let tracks = try JSONEncoder().encode(listOfTracks)
            defaults.set(tracks, forKey: DataManager.favouriteTrackKey)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func getSavedTracks() -> [Track] {
        var savedTracks = [Track]()
        
        if let data = defaults.data(forKey: DataManager.favouriteTrackKey) {
            do {
                savedTracks = try JSONDecoder().decode([Track].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
        return savedTracks
    }
}
