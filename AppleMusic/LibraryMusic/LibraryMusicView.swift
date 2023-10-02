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
    func muteMusic()
}

struct LibraryMusicView: View {
    @ObservedObject var trackModel = TrackModel.shared
    weak var tabBarDelegate: MainTabBarControllerDelegate?
    weak var delegate: LibraryMusicViewDelegate?
    
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geomerty in
                    HStack(spacing: 20) {
                        Button {
                            if let track = trackModel.tracks.first {
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
                            delegate?.muteMusic()
                        } label: {
                            Image(systemName: "speaker.slash.fill")
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
                    ForEach(trackModel.tracks) { track in
                        LibraryCell(track: track)
                    }
                    .onDelete(perform: deleteSavedTrack(at:))
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Library")
        }
    }
    
    private func deleteSavedTrack(at offsets: IndexSet) {
        trackModel.removeTrack(at: offsets)
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
