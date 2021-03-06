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
    @IBOutlet var images: [UIImageView]!
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelOriginDistance: UILabel!
    @IBOutlet weak var labelDestinationDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(place: Place) {
        for imageView in images {
            imageView.image = nil
        }
        labelName.text = place.name
        labelRank.text = "\(place.rating)"
        labelPrice.text = "\(place.priceLevel)"
        labelOriginDistance.text = place.getOriginDistanceValue()
        labelDestinationDistance.text = place.getDestinationDistance()
        #if DEBUG
        #else
        if let photos = place.photos {
            for i in 0..<min(photos.count,3) {
                let reference = photos[i].photoReference
                let urlString = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=200&photoreference=\(reference!)&key=\(ApiKey.key)"
                let url = URL(string: urlString)
                images[i].kf.setImage(with: url)
            }
        }
        #endif
    }
}
