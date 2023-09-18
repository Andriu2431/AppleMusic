//
//  TrackCell.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import UIKit
import SDWebImage

protocol TrackCellDelegate: AnyObject {
    func appendTrackForDataMaganer(cell: UITableViewCell)
    func getSavedTracks() -> [Track]
}

class TrackCell: UITableViewCell {
    static let reuseId = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackButton: UIButton!
    
    var viewModel: TrackCellViewModelProtocol? {
        willSet(newViewModel) {
            setupUI(newViewModel)
        }
    }
    
    weak var delegate: TrackCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.layer.cornerRadius = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImageView.image = nil
    }
    
    private func setupUI(_ newViewModel: TrackCellViewModelProtocol?) {
        guard let viewModel = newViewModel else { return }
        
        if let savedTracks = delegate?.getSavedTracks(),
           savedTracks.contains(where: {$0.trackName == viewModel.trackName && $0.artistName == viewModel.artistName}) {
            addTrackButton.isHidden = true
        } else {
            addTrackButton.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        trackImageView.sd_setImage(with: URL(string: viewModel.artworkUrl100 ?? ""))
    }
    
    @IBAction func addTrackTapped(_ sender: Any) {
        delegate?.appendTrackForDataMaganer(cell: self)
        addTrackButton.isHidden = true
    }
}
