//
//  LibraryMusicView.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 07.09.2023.
//

import SwiftUI

struct LibraryMusicView: View {
    var body: some View {
        NavigationView {
            VStack {
                GeometryReader { geomerty in
                    HStack(spacing: 20) {
                        Button {
                            print("12345")
                        } label: {
                            Image(systemName: "play.fill")
                                .frame(width: geomerty.size.width / 2 - 10, height: 50)
                                .tint(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                        
                        Button {
                            print("54321")
                        } label: {
                            Image(systemName: "arrow.2.circlepath")
                                .frame(width: geomerty.size.width / 2 - 10, height: 50)
                                .tint(Color.init(#colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617023, alpha: 1)))
                                .background(Color.init((#colorLiteral(red: 0.9531342387, green: 0.9490900636, blue: 0.9562709928, alpha: 1))))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding().frame(height: 50)
                Divider().padding(EdgeInsets(top: 15, leading: 15, bottom: 0, trailing: 15))
                
                List {
                    Section("All Music") {
                        LibraryCell()
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Library")
        }
    }
}

struct LibraryCell: View {
    var body: some View {
        HStack {
            Image("Image")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(5)
            VStack(alignment: .leading) {
                Text("title")
                Text("artist")
            }
        }
    }
}

struct LibraryMusic_Previews: PreviewProvider {
    static var previews: some View {
        LibraryMusicView()
    }
}
