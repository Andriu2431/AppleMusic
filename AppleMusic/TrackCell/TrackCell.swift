//
//  TrackCell.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import UIKit
import SDWebImage

class TrackCell: UITableViewCell {
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    
    var viewModel: TrackCellViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            trackNameLabel.text = viewModel.trackName
            artistNameLabel.text = viewModel.artistName
            collectionNameLabel.text = viewModel.collectionName
            trackImageView.sd_setImage(with: URL(string: viewModel.artworkUrl100 ?? ""))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
}
