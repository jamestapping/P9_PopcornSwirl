//
//  AddNoteViewController.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 27/07/2021.
//

import UIKit

class AddNoteViewController: UIViewController {

    var filmListManager = FilmListManager()
    var dataManager = DataManager()
    var trackId:Int?
    var note = ""
    
    let nc = NotificationCenter.default
    
    @IBOutlet weak var filmArtwork: UIImageView!
    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var filmNote: UITextView!
    
    @IBAction func didTapDone(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filmNote.delegate = self
        
        filmListManager.delegate = self

        overrideUserInterfaceStyle = .dark
       
        filmListManager.fetchFilmList(for: trackId!)
    }

}

extension AddNoteViewController: FilmListManagerDelegate {
    
    func didUpdateFilmList(filmList: FilmListData) {
        
        let filmTitle = filmList.results[0].trackName
        let url = filmList.results[0].artworkUrl100
        let modifiedUrl = url.replacingOccurrences(of: "100x100", with: "300x300")
        let film = dataManager.returnFilm(filmId: Int64(trackId!))
        let filmNote = film.note
        
        DispatchQueue.main.async {
            
            self.filmTitle.text = filmTitle
            
            if filmNote == "" {
                
                self.filmNote.text = "Add a note..."

            } else {
                
                self.filmNote.text = filmNote
                
            }
            

        }
        
        ImageService.loadImage(url: modifiedUrl) { [self] (image) in
            guard let image = image else { return }

            filmArtwork.image = image
        }
        
    }
    
    func didFailWithError(error: Error) {
        
        //
    }
    
}

extension AddNoteViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        //
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n"){
            textView.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Add a note..." {
            
            textView.text = ""
            
        }
        
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            
            textView.text = "Add a note..."
            note = ""
            
        } else {
            
            note = textView.text
        }

        nc.post(name: Notification.Name("didAddNote"), object: nil)
        nc.post(name: Notification.Name("reloadCollectionView"), object: nil)
        dataManager.updateFilmNote(id: Int64(trackId!), note: note)
        
    }
    
    
}
