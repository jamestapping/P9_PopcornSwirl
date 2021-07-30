//
//  FilmCollectionViewCell.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 23/06/2021.
//

import UIKit

protocol ButtonActionsDelegate {
    
    func updateFilm(cell: UICollectionViewCell, watched: Bool, bookmarked: Bool)
    func didTapNote(cell: UICollectionViewCell)
}

class FilmCollectionViewCell: UICollectionViewCell {
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            self.filmArtwork.image = nil
            self.watchedButton.isSelected = false
            self.bookmarkButton.isSelected = false
        }
    
    var delegate: ButtonActionsDelegate?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var filmArtwork: UIImageView!
    
    @IBOutlet weak var watchedButton: EyeButton!
    @IBOutlet weak var bookmarkButton: BookmarkButton!
    @IBOutlet weak var noteButton: NoteButton!
    
    
    @IBAction func didTapWatched(_ sender: Any) {
        
        let watched = watchedButton.isSelected
        let bookmarked = bookmarkButton.isSelected
        
        print ("updateFilm from filmCV cell")
        delegate?.updateFilm(cell: self, watched: watched, bookmarked: bookmarked)
        
    }
    
    @IBAction func didTapBookmark(_ sender: Any) {
        
        let watched = watchedButton.isSelected
        let bookmarked = bookmarkButton.isSelected
        
        print ("updateFilm from filmCV cell")
        delegate?.updateFilm(cell: self, watched: watched, bookmarked: bookmarked)
        
    }
    
    
    @IBAction func didTapNote(_ sender: Any) {
        
        delegate?.didTapNote(cell: self)
        
    }
    
    
    
    func updateCell() {
        
        watchedButton.isSelected = false
        
    }
    
    
}
