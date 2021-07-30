//
//  FilmListData.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 23/06/2021.
//
//

import Foundation

// MARK: - FilmList
struct FilmListData: Codable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    
    let kind: String
    let trackId: Int
    let artistName, trackName, trackCensoredName: String
    let trackViewUrl: String
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String
    let collectionPrice, trackPrice, trackRentalPrice, collectionHDPrice: Double?
    let trackHDPrice, trackHDRentalPrice: Double?
    let releaseDate: String
    let trackTimeMillis: Int?
    let country: String
    let primaryGenreName: String
    let contentAdvisoryRating: String
    let shortDescription: String?
    let longDescription: String
    let hasITunesExtras: Bool?
    let collectionID: Int?
    let collectionName, collectionCensoredName: String?
    let collectionArtistID: Int?
    let collectionArtistViewURL, collectionViewURL: String?
    let trackCount, trackNumber, discCount, discNumber: Int?

}
