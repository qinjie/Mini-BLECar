//
//  DesignableSlider.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/12/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableSlider: UISlider {
    @IBInspectable var thumbImage : UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .normal)
        }
    }
    
    @IBInspectable var thumbHighlightedImage : UIImage? {
        didSet {
            setThumbImage(thumbImage, for: .highlighted)
        }
    }
}
