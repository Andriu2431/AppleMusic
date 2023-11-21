//
//  LibraryMusicView.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 07.09.2023.
//

import SwiftUI
import URLImage
import AVKit

protocol LibraryMusicViewDelegate: AnyObject {
    var isMuteMusic: Bool {get set}
}

struct LibraryMusicView: View {
    @ObservedObject var trackModel = TrackModel.shared
    @State private var isShowingAllert = false
    @State private var track: Track!
    @State private var imageName = "speaker.wave.2.circle.fill"
    
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    weak var delegate: LibraryMusicViewDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geomerty in
                    HStack(spacing: 20) {
                        Button {
                            if let track = trackModel.tracks.first {
                                self.track = track
                                tabBarDelegate?.setTrackMovingDelegate(self)
                                tabBarDelegate?.maximizeTrackDetailController(viewModel: TrackDetailViewModel(track: track))
                            }
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geomerty.size.width / 2 - 10, height: 50)
                                .tint(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            if delegate?.isMuteMusic ?? false {
                                imageName = "speaker.slash.circle.fill"
                                delegate?.isMuteMusic = false
                            } else {
                                imageName = "speaker.wave.2.circle.fill"
                                delegate?.isMuteMusic = true
                            }
                        } label: {
                            Image(systemName: imageName)
                                .frame(width: geomerty.size.width / 2 - 10, height: 50)
                                .tint(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding().frame(height: 50)
                Divider().padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                List() {
                    ForEach(self.trackModel.tracks) { track in
                        LibraryCell(track: track)
                            .gesture(
                                LongPressGesture()
                                    .onEnded { _ in
                                        self.track = track
                                        self.isShowingAllert = true
                                    }
                                    .simultaneously(with: TapGesture()
                                        .onEnded { _ in
                                            self.track = track
                                            self.tabBarDelegate?.setTrackMovingDelegate(self)
                                            self.tabBarDelegate?.maximizeTrackDetailController(viewModel: TrackDetailViewModel(track: track))
                                        }))
                    }
                    .onDelete(perform: deleteSavedTrack(at:))
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Library")
            .confirmationDialog("", isPresented: $isShowingAllert) {
                Button("Delete", role: .destructive) {
                    self.trackModel.removeTrack(track)
                }
            } message: {
                Text("Are you sure you want to delete this track?")
            }
        }
    }
    
    private func deleteSavedTrack(at offsets: IndexSet) {
        self.trackModel.removeTrack(at: offsets)
    }
}

extension LibraryMusicView: TrackMovingDelegate {
    func moveBackForPreviousTrack() -> TrackDetailViewModelProtocol? {
        guard let index = trackModel.tracks.firstIndex(of: track) else { return nil }
        var nextTrack: Track
        
        if index - 1 == -1 {
            nextTrack = trackModel.tracks[trackModel.tracks.count - 1]
        } else {
            nextTrack = trackModel.tracks[index - 1]
        }
        
        self.track = nextTrack
        return TrackDetailViewModel(track: nextTrack)
    }
    
    func moveForwardForPreviousTrack() -> TrackDetailViewModelProtocol? {
        guard let index = trackModel.tracks.firstIndex(of: track) else { return nil }
        var nextTrack: Track
        
        if index + 1 == trackModel.tracks.count {
            nextTrack = trackModel.tracks[0]
        } else {
            nextTrack = trackModel.tracks[index + 1]
        }
        
        self.track = nextTrack
        return TrackDetailViewModel(track: nextTrack)
    }
}

struct LibraryCell: View {
    var track: Track
    
    var body: some View {
        HStack {
            let url = URL(string: track.artworkUrl100 ?? "Image")
            URLImage(url!) { image in
                image
                    .resizable()
                    .cornerRadius(5)
            }
            .frame(width: 60, height: 60)

            VStack(alignment: .leading) {
                Text(track.trackName)
                Text(track.artistName)
            }
        }
    }
}

struct LibraryMusic_Previews: PreviewProvider {
    static var previews: some View {
        LibraryMusicView()
    }
}
