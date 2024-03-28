//
//  UIImageView+Extensions.swift
//  MarvelShop
//
//  Created by Charlie
//

import UIKit
import Kingfisher


extension UIImageView {

    func setImage(_ urlString: String?, placeholder: ImagePlaceholder? = nil, usesFadeTransition: Bool = false) {
        guard
            let _urlString = urlString,
            let url = URL(string: _urlString)
        else {
            self.image = placeholder?.image
            return
        }

        var options: [KingfisherOptionsInfoItem] = []

        if usesFadeTransition {
            options.append(contentsOf: [.transition(.fade(0.3))])
        }

        self.kf.setImage(with: url, placeholder: placeholder?.image, options: options)
    }

    func cancelDownload() {
        self.kf.cancelDownloadTask()
    }

}

enum ImagePlaceholder {

    case character

    var image: UIImage {
        switch self {
        case .character:
            return UIImage(named: "placeholder_character")!
        }
    }

}
