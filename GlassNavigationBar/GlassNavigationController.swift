//
//  GlassNavigationController.swift
//  GlassNavigationBar
//
//  Created by 홍창남 on 2018. 5. 20..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import UIKit

open class GlassNavigationController: UINavigationController {

    open var contentHeight: CGFloat?

    open var color: UIColor = .white {
        didSet {
            self.setBackground(color: color)
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

    public func extendedLayoutIncludesOpaqueBars(_ viewController: UIViewController) {
        viewController.extendedLayoutIncludesOpaqueBars = true
    }
    
    public func setNavbarTheme(isTransparent: Bool, scrollView: UIScrollView, color: UIColor? = nil,
                               tintColor: UIColor? = nil, hideBottomHairline: Bool? = nil,
                               contentHeight: CGFloat? = nil) {
        self.color = color ?? .white
        self.navigationBar.tintColor = tintColor ?? .black
        self.isTransparent = isTransparent
        self.hideNavigationBottomLine = hideBottomHairline ?? true

        self.contentHeight = {
            guard let height = contentHeight else { return nil }

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

        adjustNavigationAlpha(scrollView: scrollView)
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

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

// MARK: UIScrollViewDelegate

extension GlassNavigationController: UIScrollViewDelegate {

    public func adjustNavigationAlpha(scrollView: UIScrollView) {
        func scrollingBackground(color: UIColor, isTranslucent: Bool) {
            setBackground(color: color)
            self.navigationBar.isTranslucent = isTranslucent
        }

        let offsetY = scrollView.contentOffset.y

        let alpha: CGFloat = {
            if let maxHeight = contentHeight {
                return offsetY / maxHeight
            }

            let alpha = offsetY / (scrollView.contentSize.height - scrollView.frame.size.height)

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
            scrollingBackground(color: self.color.withAlphaComponent(alpha), isTranslucent: alpha < 1.0)
        } else {
            scrollingBackground(color: self.color.withAlphaComponent(0.0), isTranslucent: true)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustNavigationAlpha(scrollView: scrollView)
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
            let background = setImageFrom(color: self.color.withAlphaComponent(self.navigationBar.alpha))
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
