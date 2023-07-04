//
//  TrackDetailView.swift
//  IMusic
//
//  Created by macbook on 04.07.2023.
//

import UIKit

class TrackDetailView: UIView {

    @IBOutlet weak var trackImageView: UIImageView!
    
    @IBOutlet weak var currentTimesSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
    @IBAction func heandleCurrentTimerSlider(_ sender: Any) {
    }
    
    
    @IBAction func heandleVolumeSlider(_ sender: Any) {
    }
    
    
    @IBAction func previousTrack(_ sender: Any) {
    }
    
    @IBAction func nextTrack(_ sender: Any) {
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
