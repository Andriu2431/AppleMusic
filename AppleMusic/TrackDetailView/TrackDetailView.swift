//
//  TrackDetailView.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import UIKit

class TrackDetailView: UIView {
    
    var viewModel: TrackDetailViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            trackTitleLabel.text = viewModel.trackName
        }
    }
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.backgroundColor = .green
    }
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
    }
    
    @IBAction func previousTrackButtonTapped(_ sender: Any) {
    }
    
    @IBAction func nextTrackButtonTapped(_ sender: Any) {
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
    }
    
    
}
