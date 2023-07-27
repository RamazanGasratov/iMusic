//
//  TrackCell.swift
//  IMusic
//
//  Created by macbook on 01.07.2023.
//
import Foundation
import UIKit
import SDWebImage

protocol TrackCellViewModel {
    var iconUrlString: String? { get }
    var trackName: String { get }
    var artistName: String { get }
    var collectionName: String { get }
}

class TrackCellView: UITableViewCell {
    
    static let identifier = "TrackCell"
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionNameLabel: UILabel!
    @IBOutlet weak var addTrackOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        artistNameLabel.textColor = .lightGray
        collectionNameLabel.textColor = .lightGray
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        trackImageView.image = nil
    }
    
    var cell: SearchViewModel.Cell?
    
    func set(viewModel: SearchViewModel.Cell) {
        
        self.cell = viewModel
        
        let saveTracks = UserDefaults.standard.savedTracks()
         let hasFavourite = saveTracks.firstIndex(where: {
            $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
        }) != nil
        if hasFavourite {
            addTrackOutlet.isHidden = true
        } else {
            addTrackOutlet.isHidden = false
        }
        
        trackNameLabel.text = viewModel.trackName
        artistNameLabel.text = viewModel.artistName
        collectionNameLabel.text = viewModel.collectionName
        
        guard let url = URL(string: viewModel.iconUrlString ?? "") else {return}
        trackImageView.sd_setImage(with: url)
    }
    
    
    @IBAction func addTrackAction(_ sender: Any) {
        let defults = UserDefaults.standard
        guard let cell = cell else { return }
        addTrackOutlet.isHidden = true
        var listOfTracks = defults.savedTracks()
        listOfTracks.append(cell)
       
        if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: listOfTracks,
                                                            requiringSecureCoding: false) {
            print("Успешно")
            defults.set(saveData, forKey: UserDefaults.favouriteTrackKey)
        }
    }
}
