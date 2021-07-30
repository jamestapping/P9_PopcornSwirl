//
//  NoteButton.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 28/07/2021.
//

import Foundation
import UIKit

class NoteButton: UIButton {

    let off = UIImage(systemName: "square.and.pencil")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
    let on = UIImage(systemName: "square.and.pencil")?.withTintColor(UIColor.red, renderingMode: .alwaysOriginal)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }
    
    deinit {
    
    }
    
    func initButton() {
        
        adjustsImageWhenHighlighted = false
        
        setImage(off, for: .normal)
        
        setImage(on, for: .selected)
    }
    
}
