//
//  FilmDetailInfoCell.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 30/06/2021.
//

import UIKit

class FilmDetailInfoCell: UITableViewCell {

    @IBOutlet weak var filmTitle: UILabel!
    @IBOutlet weak var dateDuration: UILabel!
    @IBOutlet weak var filmDescription: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
