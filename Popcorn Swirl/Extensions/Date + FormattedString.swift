//
//  Date + FormattedString.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 05/07/2021.
//

import Foundation

// Convert the date we get from the API to a traditional date style

extension String {
  func stringDateAsFormattedString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    let myDate = dateFormatter.date(from: self)!
    dateFormatter.dateStyle = .medium
    let myDateString = dateFormatter.string(from: myDate)
    return myDateString
  }
}

