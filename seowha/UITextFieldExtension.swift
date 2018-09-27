//
//  UITextFieldExtension.swift
//  seowha
//
//  Created by Jinsoo Heo on 27/09/2018.
//  Copyright © 2018 TeamSeowha. All rights reserved.
//

import UIKit

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height-height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
