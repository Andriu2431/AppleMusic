//
//  CMTime + Extension.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 19.06.2023.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDispalyString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minuets = totalSecond / 60
        let timeFormatString = String(format: "%02d:%02d", minuets, seconds)
        return timeFormatString
    }
}
