//
//  FilmDetailButtonsCell.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 06/07/2021.
//

import UIKit

protocol DetailButtonActionsDelegate {
    
    func updateFilm(watched: Bool, bookmarked: Bool)
    func didTapNoteButton()
}

class FilmDetailButtonsCell: UITableViewCell {
    
    let nc = NotificationCenter.default

    var delegate: DetailButtonActionsDelegate?

    @IBOutlet weak var watchedButton: EyeButton!
    @IBOutlet weak var bookmarkButton: BookmarkButton!
    @IBOutlet weak var noteButton: NoteButton!
    
    @IBAction func didTapWatched(_ sender: Any) {
        
        let watched = watchedButton.isSelected
        let bookmarked = bookmarkButton.isSelected
        
        nc.post(name: Notification.Name("reloadCollectionView"), object: nil)
        nc.post(name: Notification.Name("reloadTableView"), object: nil)
        
        print ("updateFilm from detail button cell - didTapWatched")
        delegate?.updateFilm(watched: watched, bookmarked: bookmarked)
        
    }
    
    
    @IBAction func didTapBookmark(_ sender: Any) {
        
        let watched = watchedButton.isSelected
        let bookmarked = bookmarkButton.isSelected
        
        nc.post(name: Notification.Name("reloadCollectionView"), object: nil)
        nc.post(name: Notification.Name("reloadTableView"), object: nil)
        
        print ("updateFilm from detail button cell - didTapBookmark")
        delegate?.updateFilm(watched: watched, bookmarked: bookmarked)
        
    }
    
    @IBAction func didTapAddNote(_ sender: Any) {
        
        delegate?.didTapNoteButton()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
