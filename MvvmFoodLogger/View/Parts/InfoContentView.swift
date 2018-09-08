//
//  InfoContentView.swift
//  MvvmFoodLogger
//
//  Created by Takahiro Kato on 2018/09/07.
//  Copyright © 2018年 Takahiro Kato. All rights reserved.
//

import Foundation
import UIKit

final class InfoContentView: UIView {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var addFavoriteButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibViewSet()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.xibViewSet()
    }

    internal func xibViewSet() {
        if let view = R.nib.infoContentView().instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }

    func setup(name: String, defaultImage: UIImage? = R.image.noImage()) {
        nameLabel.text = name
        imageView.image = defaultImage
    }

    func configureImage(_ image: UIImage?) {
        imageView.image = image
    }
}
