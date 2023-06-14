//
//  TrackCellProtocol.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import Foundation

protocol TrackCellViewModelProtocol {
    var trackName: String {get}
    var artistName: String {get}
    var collectionName: String {get}
    var artworkUrl100: String? {get}
}
