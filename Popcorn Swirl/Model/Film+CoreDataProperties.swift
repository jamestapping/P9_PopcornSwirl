//
//  Film+CoreDataProperties.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 21/07/2021.
//
//

import Foundation
import CoreData


extension Film {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film> {
        return NSFetchRequest<Film>(entityName: "Film")
    }

    @NSManaged public var bookmarked: Bool
    @NSManaged public var filmId: Int64
    @NSManaged public var note: String?
    @NSManaged public var watched: Bool

}

extension Film : Identifiable {

}
