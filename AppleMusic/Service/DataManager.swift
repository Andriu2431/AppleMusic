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
    
    func saveTracks(_ tracks: [Track]) {
        do {
            let data = try JSONEncoder().encode(tracks)
            defaults.set(data, forKey: DataManager.favouriteTrackKey)
        } catch let error {
            print(error.localizedDescription)
        }
    }
//    
//    func appendNewTrack(_ track: Track) {
//        var listOfTracks = getSavedTracks()
//        listOfTracks.append(track)
//        
//        do {
//            let data = try JSONEncoder().encode(listOfTracks)
//            defaults.set(data, forKey: DataManager.favouriteTrackKey)
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
    
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
