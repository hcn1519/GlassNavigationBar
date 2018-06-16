//
//  GlassNavigationController.swift
//  GlassNavigationBar
//
//  Created by 홍창남 on 2018. 5. 20..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import UIKit

public typealias ColorSet = (UIColor, UIColor)

public struct NavigationOptions {
    var backgroundColor: UIColor?
    var tintColor: UIColor?
    var hideBottomHairline: Bool?
    var contentHeight: CGFloat?
    var scrollViewStartOffsetY: CGFloat = 0
    var navigationItemIsTransparent: Bool? = false
}

extension NavigationOptions {
    init(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }

    init(tintColor: UIColor) {
        self.tintColor = tintColor
    }

    init(backgroundColor: UIColor?, tintColor: UIColor?, hideBottomHairline: Bool?, contentHeight: CGFloat?) {
        self.backgroundColor = backgroundColor
        self.tintColor = tintColor
        self.hideBottomHairline = hideBottomHairline
        self.contentHeight = contentHeight
    }
}

open class GlassNavigationController: UINavigationController {

    open var contentHeight: CGFloat?
    open var startOffset: CGFloat = 0.0

    open var scrollViewStartOffsetY: CGFloat = 0.0

    open var tintColorSet: ColorSet?
    open var backgroundColorSet: ColorSet?

    open var navigationItemAlpha: CGFloat = 0.0 {
        didSet {
            self.navigationBar.tintColor = self.navigationBar.tintColor.withAlphaComponent(navigationItemAlpha)
        }
    }

    open var adjustNavigationItemTransparency: Bool = false {
        didSet {
            if adjustNavigationItemTransparency {
                self.navigationBar.tintColor = self.navigationBar.tintColor.withAlphaComponent(navigationItemAlpha)
            }
        }
    }

    open var backgroundColor: UIColor = .white {
        didSet {
            self.setBackground(color: backgroundColor)
        }
    }

    open var isTransparent: Bool = true {
        didSet {
            self.setTransparent(isTransparent)
        }
    }

    open var hideNavigationBottomLine: Bool {
        get {
            return self.navigationBar.hairlineImageView?.isHidden ?? false
        } set {
            self.navigationBar.hairlineImageView?.isHidden = newValue
            if !newValue {
                self.navigationBar.shadowImage = nil
            }
        }
    }

    public func setTitleColor(color: UIColor) {
        self.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedStringKey.foregroundColor: color]
        self.navigationBar.titleTextAttributes = textAttributes

        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = textAttributes
        }
    }

    public func setTitleAttribute(attribute: [NSAttributedStringKey: Any]) {
        self.navigationBar.barStyle = .default
        self.navigationBar.titleTextAttributes = attribute

        if #available(iOS 11.0, *) {
            self.navigationBar.largeTitleTextAttributes = attribute
        }
    }

    public func extendedLayoutIncludesOpaqueBars(_ viewController: UIViewController, scrollView: UIScrollView) {
        viewController.extendedLayoutIncludesOpaqueBars = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    public func setColor(scrollView: UIScrollView, tintColorSet: ColorSet? = nil, backgroundColorSet: ColorSet? = nil) {
        self.tintColorSet = tintColorSet
        self.backgroundColorSet = backgroundColorSet
        adjustNavigationAlpha(scrollView: scrollView)
    }

    public func setNavigationTheme(isTransparent: Bool, scrollView: UIScrollView, options: NavigationOptions? = nil) {

        self.isTransparent = isTransparent

        if let options = options {
            self.backgroundColor = options.backgroundColor ?? .white
            self.navigationBar.tintColor = options.tintColor ?? .black

            self.hideNavigationBottomLine = options.hideBottomHairline ?? false
            self.contentHeight = {
                guard let height = options.contentHeight else { return nil }

                let navBarHeight: CGFloat = {
                    if #available(iOS 11.0, *) {
                        if self.navigationBar.prefersLargeTitles {
                            return 44
                        }
                    }
                    return self.navigationBar.frame.height
                }()

                let statusBarHeight = UIApplication.shared.statusBarFrame.size.height

                return height - navBarHeight - statusBarHeight
            }()

            self.scrollViewStartOffsetY = options.scrollViewStartOffsetY

        } else {
            self.backgroundColor = .white
            self.navigationBar.tintColor = .black
            setTitleColor(color: .black)
        }
        adjustNavigationAlpha(scrollView: scrollView)

        self.backgroundColorSet = nil
        self.tintColorSet = nil
    }

    public func scrollViewAboveNavigation(scrollView: UIScrollView) {

        let offset: CGFloat = {
            let navBarHeight = self.navigationBar.frame.size.height
            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height

            if #available(iOS 11.0, *) {
                return 0
            }
            return navBarHeight + statusBarHeight
        }()

        scrollView.contentInset.top = offset * -1
    }
}

// MARK: UIScrollViewDelegate

extension GlassNavigationController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustNavigationAlpha(scrollView: scrollView)

        let length = contentHeight ?? scrollView.contentSize.height - scrollView.frame.size.height
        adjustGradientColor(length: length, offsetY: scrollView.contentOffset.y)

    }

    public func adjustNavigationAlpha(scrollView: UIScrollView) {
        func scrollingBackground(color: UIColor, isTranslucent: Bool) {
            setBackground(color: color)
            self.navigationBar.isTranslucent = isTranslucent
        }

        let offsetY: CGFloat = {
            let firstOffset = scrollViewStartOffsetY < 0 ? scrollViewStartOffsetY * -1 : scrollViewStartOffsetY
            return scrollView.contentOffset.y + firstOffset
        }()

        let alpha: CGFloat = {
            if let maxHeight = contentHeight {
                return offsetY / maxHeight
            }

            let alpha: CGFloat = {
                let totalHeight = scrollView.contentSize.height - scrollView.frame.size.height
                return totalHeight != 0 ? offsetY / totalHeight : 0
            }()

            switch alpha {
            case _ where alpha < 0:
                return 0
            case _ where alpha > 1:
                return 1
            default:
                return alpha
            }
        }()

        let contentInsetTop = scrollView.contentInset.top * -1

        if offsetY > contentInsetTop {
            scrollingBackground(color: self.backgroundColor.withAlphaComponent(alpha), isTranslucent: alpha < 1.0)
        } else {
            scrollingBackground(color: self.backgroundColor.withAlphaComponent(0.0), isTranslucent: true)
        }

        if adjustNavigationItemTransparency {
            self.navigationItemAlpha = alpha
        }

    }

    func adjustGradientColor(length: CGFloat, offsetY: CGFloat) {

        if let backgroundColorSet = backgroundColorSet {

            let backgroundColor = UIColor.setGradient(colorSet: backgroundColorSet, totalLength: length, current: offsetY)

            self.setBackground(color: backgroundColor)
        }
        if let tintColorSet = tintColorSet {
            let tintColor = UIColor.setGradient(colorSet: tintColorSet, totalLength: length, current: offsetY)

            self.navigationBar.tintColor = tintColor
            self.setTitleAttribute(attribute: [NSAttributedStringKey.foregroundColor: tintColor])
        }
    }
}

extension GlassNavigationController {

    public func setBackground(color: UIColor) {
        self.navigationBar.setBackgroundImage(setImageFrom(color: color), for: UIBarMetrics.default)
    }

    public func setNavBarToDefault() {
        if #available(iOS 11.0, *) {
            self.navigationBar.prefersLargeTitles = false
        }
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = true
        self.navigationBar.tintColor = nil
        self.navigationBar.barTintColor = nil
        self.navigationBar.hairlineImageView?.isHidden = false
        self.navigationBar.setBackgroundImage(setImageFrom(color: #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)), for: .default)
    }

    private func setImageFrom(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)

        UIGraphicsBeginImageContext(rect.size)
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)
        }
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }
        return UIImage()
    }

    private func setTransparent(_ isTransParent: Bool) {
        if isTransParent {
            self.navigationBar.isTranslucent = true
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
        } else {
            let background = setImageFrom(color: self.backgroundColor.withAlphaComponent(self.navigationBar.alpha))
            self.navigationBar.setBackgroundImage(background, for: .default)
        }
    }

}

// MARK: Remove HairLine

extension UINavigationBar {
    fileprivate var hairlineImageView: UIImageView? {
        return hairlineImageView(in: self)
    }

    fileprivate func hairlineImageView(in view: UIView) -> UIImageView? {
        if let imageView = view as? UIImageView, imageView.bounds.height <= 1.0 {
            return imageView
        }
        for subview in view.subviews {
            if let imageView = self.hairlineImageView(in: subview) { return imageView }
        }

        return nil
    }
}
