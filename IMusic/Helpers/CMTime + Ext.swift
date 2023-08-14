//
//  CMTime + Ext.swift
//  IMusic
//
//  Created by macbook on 06.07.2023.
//

import Foundation
import AVKit

extension CMTime {
    
    func toDispalayString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSecond = Int(CMTimeGetSeconds(self))
        let seconds = totalSecond % 60
        let minutes = totalSecond / 60
        let timeForatString = String(format: "%02d:%02d", minutes, seconds)
        return timeForatString
    }
}
