//
//  FilmListManager.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 23/06/2021.
//
// Example requests
//
// http://itunes.apple.com/lookup?id=1561316628
// https://itunes.apple.com/search?term=2021&entity=movie&media=movie&attribut=releaseYearTerm
//
// See Constants.swift

import Foundation

protocol FilmListManagerDelegate {
    func didUpdateFilmList(filmList: FilmListData)
    func didFailWithError(error: Error)
}

struct FilmListManager {
    
    var currentYear: String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yearString = dateFormatter.string(from: date)
        
        return yearString
    }
    
    var delegate: FilmListManagerDelegate?
    
    func fetchFilmList(for trackId:Int) {
        let urlString = "\(Constants.filmListLookupURL)\(trackId)"
        performRequest(with: urlString)
    }
    
    func fetchFilmList() {
        let urlString = "\(Constants.filmListURL)"
        let urlStringModifiedforYear = urlString.replacingOccurrences(of: "yyyy", with: currentYear)
        performRequest(with: urlStringModifiedforYear)
    }
    
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                    self.delegate?.didFailWithError(error: error!)
                    
                    return
                }
                
                if let safeData = data {
                    if let filmList = self.parseJSON(safeData) {
                        
                        self.delegate?.didUpdateFilmList(filmList: filmList)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ filmListData: Data) -> FilmListData? {
        let decoder = JSONDecoder()
        do {
            let filmList = try decoder.decode(FilmListData.self, from: filmListData)
           
            return filmList
            
        } catch {
            
            delegate?.didFailWithError(error: error)
            
            return nil
        }
    }
    
}
