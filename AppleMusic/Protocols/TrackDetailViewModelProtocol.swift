//
//  TrackDetailViewModelProtocol.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 15.06.2023.
//

import Foundation

protocol TrackDetailViewModelProtocol {
    var trackName: String {get}
    var artistName: String {get}
    var collectionName: String {get}
    var artworkUrl100: String? {get}
    var previewUrl: String? {get}
}
