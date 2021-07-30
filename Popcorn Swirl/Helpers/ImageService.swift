//
//  Image.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 24/06/2021.
//

import Foundation
import UIKit

struct ImageService {
    
    // MARK: - Image Loading
    static func loadImage(url: String, completion: @escaping (UIImage?) -> ()) {
                
            let utilityQueue = DispatchQueue.global(qos: .utility)
        
            utilityQueue.async {
                let url = URL(string: url)!
                
                guard let data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }

    
}

