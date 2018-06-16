//
//  GlassNavigation+Color.swift
//  GlassNavigationBar
//
//  Created by 홍창남 on 2018. 6. 1..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import Foundation
import UIKit

struct RGBAColor {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
}

extension UIColor {
    var rgbaColor: RGBAColor {
        var rgbaColor = RGBAColor(red: 0, green: 0, blue: 0, alpha: 0)
        self.getRed(&rgbaColor.red, green: &rgbaColor.green, blue: &rgbaColor.blue, alpha: &rgbaColor.alpha)
        return rgbaColor
    }

    static func setGradient(colorSet: ColorSet, totalLength: CGFloat, current: CGFloat) -> UIColor {

        let startColorValue = colorSet.0.rgbaColor
        let endColorValue = colorSet.1.rgbaColor

        let redSet = CGPoint(x: startColorValue.red, y: endColorValue.red)
        let greenSet = CGPoint(x: startColorValue.green, y: endColorValue.green)
        let blueSet = CGPoint(x: startColorValue.blue, y: endColorValue.blue)

        let red = calculateColor(colorValue: redSet, totalLength: totalLength, currentPoint: current)
        let green = calculateColor(colorValue: greenSet, totalLength: totalLength, currentPoint: current)
        let blue = calculateColor(colorValue: blueSet, totalLength: totalLength, currentPoint: current)

        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    private static func calculateColor(colorValue: CGPoint, totalLength: CGFloat, currentPoint: CGFloat) -> CGFloat {

        let startValue = colorValue.x / 255 + colorValue.x.truncatingRemainder(dividingBy: 255)
        let endValue = colorValue.y / 255 + colorValue.y.truncatingRemainder(dividingBy: 255)

        if colorValue.x < colorValue.y {
            let plus = ((endValue - startValue) / totalLength) * currentPoint
            return startValue + plus
        } else if colorValue.x > colorValue.y {
            let minus = ((startValue - endValue) / totalLength) * currentPoint
            return startValue - minus
        } else {
            return 1
        }
    }
}
