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
            observePlayerCurruntTime()
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
        trackImageView.layer.cornerRadius = 10
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        changeScaleImageView()
    }
    
    private func changeScaleImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut) {
            if self.player.timeControlStatus == .paused {
                self.trackImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            } else {
                self.trackImageView.transform = .identity
            }
        }
        
    }
    
    private func observePlayerCurruntTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTimeLabel.text = time.toDispalyString()
            
            let durationTime = self?.player.currentItem?.duration
            let currtentDurationTime = (durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time
            self?.durationLabel.text = "-\(currtentDurationTime.toDispalyString())"
            
            self?.updateCurrentTimeSlider()
        }
    }
    
    private func updateCurrentTimeSlider() {
        let currentTimeSecond = CMTimeGetSeconds(player.currentTime())
        let durationSecons = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        self.currentTimeSlider.value = Float(currentTimeSecond / durationSecons)
    }
    
    // MARK: @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        guard let duartion = player.currentItem?.duration else { return }
    
        let durationInSeconds = CMTimeGetSeconds(duartion)
        // так ми найдемо, де ми находимось по часу
        let seekTimeInSeconds = Float64(currentTimeSlider.value) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
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
        changeScaleImageView()
    }
}
