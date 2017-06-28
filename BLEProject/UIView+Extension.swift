//
//  UIView+Border+Extension.swift
//  irecruit
//
//  Created by Plus Pingya on 1/18/2559 BE.
//  Copyright © 2559 irecruit. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func makeMyCornerRounded(_ ratio: CGFloat) {
        self.layer.cornerRadius = self.frame.size.height * ratio
        self.layer.masksToBounds = true
    }
    
    func makeMyCornerRounded() {
        makeMyCornerRounded(0.2)
    }
    
    func makeMeCircled() {
        makeMyCornerRounded(0.5)
    }
    
}
