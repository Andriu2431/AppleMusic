//
//  TrackDetailView.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 14.06.2023.
//

import UIKit
import SDWebImage
import AVKit

protocol TrackMovingDelegate: AnyObject {
    func moveBackForPreviousTrack() -> TrackDetailViewModelProtocol?
    func moveForwardForPreviousTrack() -> TrackDetailViewModelProtocol?
}

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: CustomSlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: CustomSlider!
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    
    
    var viewModel: TrackDetailViewModelProtocol? {
        willSet(newViewModel) {
            guard let viewModel = newViewModel else { return }
            setupUI(viewModel)
        }
    }
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    
    private let player: AVPlayer = {
       let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGestures()
        trackImageView.backgroundColor = .gray
        trackImageView.layer.cornerRadius = 10
        miniTrackImageView.layer.cornerRadius = 5
        
        miniPlayPauseButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
    }
    
    private func setupUI(_ viewModel: TrackDetailViewModelProtocol) {
        miniTrackTitleLabel.text = viewModel.trackName
        trackTitleLabel.text = viewModel.trackName
        authorTitleLabel.text = viewModel.artistName
        
        // resize a photo with 100x100 on 600x600
        let url = URL(string: viewModel.artworkUrl100?.replacingOccurrences(of: "100x100", with: "600x600") ?? "")
        trackImageView.sd_setImage(with: url)
        miniTrackImageView.sd_setImage(with: url)
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.playTrack(previewUrl: viewModel.previewUrl)
        }
        observePlayerCurruntTime()
    }
    
    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        DispatchQueue.main.async { [weak self] in
            self?.player.volume = self?.volumeSlider.value ?? 0
            self?.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self?.miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self?.changeScaleImageView()
        }
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
    
    // MARK: GestureRecognizer
    
    private func setupGestures() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTapMaximizedView)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(openPanMaximizedView)))
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(clousePanMaximizedView)))
    }
    
    @objc private func openTapMaximizedView() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    @objc private func openPanMaximizedView(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
        default:
            print("default")
        }
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.transform = .identity
            if translation.y < -300 || velocity.y < -500 {
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }
    }
    
    @objc private func clousePanMaximizedView(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        
        switch gesture.state {
        case .changed:
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 1,
                           options: .curveEaseOut) {
                self.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimizeTrackDetailController()
                }
            }
        default :
            print("Default")
        }
    }
    
    // MARK: @IBAction
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        tabBarDelegate?.minimizeTrackDetailController()
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
        let newViewModel = delegate?.moveBackForPreviousTrack()
        self.viewModel = newViewModel
    }
    
    @IBAction func nextTrackButtonTapped(_ sender: Any) {
        let newViewModel = delegate?.moveForwardForPreviousTrack()
        self.viewModel = newViewModel
    }
    
    @IBAction func playPauseButtonTapped(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
        changeScaleImageView()
    }
}

extension TrackDetailView: LibraryMusicViewDelegate {
    
    func muteMusic() {
        self.volumeSlider.value = 0
        self.player.volume = 0
    }
}
