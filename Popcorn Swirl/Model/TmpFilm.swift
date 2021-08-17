//
//  TmpFilm.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 08/07/2021.
//

import UIKit

class TmpFilm {

    var filmId: Int64
    var watched: Bool
    var bookmarked: Bool
    var note: String

    init(filmId: Int64, watched: Bool, bookmarked:Bool, note: String) {
        self.filmId = filmId
        self.watched = watched
        self.bookmarked = bookmarked
        self.note = note

    }
}

