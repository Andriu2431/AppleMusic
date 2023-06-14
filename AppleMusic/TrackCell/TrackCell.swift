//
//  TrackCell.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import UIKit

class TrackCell: UITableViewCell {
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var imageTrack: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    var viewModel: TrackCellViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            trackNameLabel.text = viewModel.trackName
            artistNameLabel.text = viewModel.artistName
            collectionNameLabel.text = viewModel.collectionName
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
