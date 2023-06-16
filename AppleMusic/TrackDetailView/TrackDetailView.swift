//
//  TrackDetailView.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import UIKit
import SDWebImage
import AVKit

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    var viewModel: TrackDetailViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            trackTitleLabel.text = viewModel.trackName
            authorTitleLabel.text = viewModel.artistName
            
            // resize a photo with 100x100 on 600x600
            let url = URL(string: viewModel.artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600") ?? "")
            trackImageView.sd_setImage(with: url)
            
            playTrack(previewUrl: viewModel.previewUrl)
        }
    }
    
    private let player: AVPlayer = {
       let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        trackImageView.backgroundColor = .gray
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    // MARK: @IBAction
    
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
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
    
    
}
