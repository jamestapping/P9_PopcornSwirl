//
//  FilmDetailAdmobCell.swift
//  Popcorn Swirl
//
//  Created by James Tapping on 29/07/2021.
//

import UIKit
import GoogleMobileAds

class FilmDetailAdmobCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
     bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        self.addSubview(bannerView)
    }
    

}
