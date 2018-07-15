//
//  CollectionViewCell.swift
//  GlassNavigationBarExample
//
//  Created by Seong ho Hong on 2018. 7. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: CollectionViewCell!
}

extension CGFloat {
    static var random: CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random, green: .random, blue: .random, alpha: 1.0)
    }
}
