//
//  DataManager.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 23/06/2021.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    var tmpFilm: TmpFilm?

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK:- Goal CRUD methods

    func createNewFilm(id: Int64, watched: Bool, bookmarked: Bool, note: String = "" ) {
        
        let newFilm = Film(context: context)
        newFilm.filmId = id
        newFilm.watched = watched
        newFilm.bookmarked = bookmarked
        newFilm.note = note
    
        saveContext()
        
    }
    
    func updateFilm(id: Int64, watched: Bool, bookmarked: Bool) {
        
        let request = Film.fetchRequest() as NSFetchRequest<Film>
        
        request.predicate = NSPredicate(format: "%K == %i", #keyPath(Film.filmId), id as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            if result.count != 0 {
    
                let fetchedFilm = result.first!
                
                fetchedFilm.watched = watched
                fetchedFilm.bookmarked = bookmarked

                saveContext()
                
            } else {
                
                // print("Fetch result was empty for filmId: \(String(describing: id))")
                
                createNewFilm(id: id,watched: watched, bookmarked: bookmarked, note: "")
                
            }
            
        } catch { print("Fetch on film \(String(describing: id)) failed. \(error)") }
        
    }
    
    func updateFilmNote(id: Int64, note: String?) {
        
        let request = Film.fetchRequest() as NSFetchRequest<Film>
        
        request.predicate = NSPredicate(format: "%K == %i", #keyPath(Film.filmId), id as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            if result.count != 0 {
    
                let fetchedFilm = result.first!
                
                fetchedFilm.note = note

                saveContext()
                
            } else {
                
                // print("Fetch result was empty for filmId: \(String(describing: id))")
                
                let watched = false
                let bookmarked = false
                
                createNewFilm(id: id,watched: watched, bookmarked: bookmarked, note: note!)
                
            }
            
        } catch { print("Fetch on film \(String(describing: id)) failed. \(error)") }
        
    }
    
    // Search Film by filmId
    
    func returnFilm(filmId: Int64) -> TmpFilm {
        
        let request = Film.fetchRequest() as NSFetchRequest<Film>
        request.predicate = NSPredicate(format: "%K == %i", #keyPath(Film.filmId), filmId as CVarArg)
        
        do {
            
            let result = try context.fetch(request)
            if result.count != 0 {
                
                let fetchedfilm = result.first!

                tmpFilm = TmpFilm(filmId: filmId, watched: fetchedfilm.watched, bookmarked: fetchedfilm.bookmarked, note: fetchedfilm.note!)
                
                return tmpFilm!
                
            } // else { print("Fetch result was empty for specified film id: \(String(describing: filmId))") }
            
        } catch { print("Fetch on film id: \(String(describing: filmId)) failed. \(error)") }
        
        return TmpFilm.init(filmId: 00000000,watched: false, bookmarked: false, note: "") }
    
    // Get all records
    
    func returnFilmList() -> [Film] {
        
        let request = Film.fetchRequest() as NSFetchRequest<Film>
        
        do {
            
        let result = try context.fetch(request)
            
            return result
        }
        
        catch {
            
            // Error ?
            
        }
        
        return []
        
    }
    
    func saveContext() {
        do {
            try context.save()
        }
        catch {
            
            context.rollback()
        }
    }
}
