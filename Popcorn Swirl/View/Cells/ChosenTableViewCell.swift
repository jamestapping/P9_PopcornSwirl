//
//  BookmarkedTableViewCell.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 18/07/2021.
//

import UIKit

class ChosenTableViewCell: UITableViewCell {
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
            // self.artwork.image = nil
        
        }
    
    @IBOutlet weak var artwork: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var detail: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


