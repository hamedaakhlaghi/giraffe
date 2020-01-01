//
//  PlaceTableViewCell.swift
//  RuziVoy
//
//  Created by Hamed on 12/30/19.
//  Copyright © 2019 Hamed. All rights reserved.
//

import UIKit
import GooglePlaces
import Kingfisher
class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imagePlace: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(place: Place) {
        labelName.text = place.name
        labelRank.text = "\(place.rating)"
        labelPrice.text = "\(place.priceLevel)"
        if let photos = place.photos {
            let reference = photos[0].photoReference
            let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference!)&key=\(ApiKey.key)"
            let url = URL(string: urlString)
            imagePlace.kf.setImage(with: url)
        }
    }
}
