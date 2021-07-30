//
//  EyeButton.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 6/7/2021.
//

import Foundation
import UIKit

class EyeButton: UIButton {

    let off = UIImage(systemName: "eye")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
    let on = UIImage(systemName: "eye.fill")?.withTintColor(UIColor.red, renderingMode: .alwaysOriginal)
    
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
        addTarget(self, action: #selector(activateButton), for: .touchUpInside)
        
        setImage(off, for: .normal)
        
        setImage(on, for: .selected)
    }
    
    @objc func activateButton(){
        
        isSelected.toggle()
        
   }
    
}
