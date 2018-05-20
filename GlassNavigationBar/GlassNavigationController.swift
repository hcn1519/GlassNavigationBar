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
    open var startTintColor: UIColor?
    open var endTintColor: UIColor?

    open override func awakeFromNib() {
        super.awakeFromNib()

        if #available(iOS 11.0, *) {
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

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

    open var hideBottomNavigationLine: Bool {
        get {
            if let hairLine = self.navigationBar.hairlineImageView {
                return hairLine.isHidden
            }
            return false
        } set {
            self.navigationBar.hairlineImageView?.isHidden = newValue
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
    
    public func setNavbarTheme(scrollView: UIScrollView, isTransparent: Bool, color: UIColor? = nil,
                               tintColor: UIColor? = nil, hideBottomHairline: Bool? = nil,
                               contentHeight: CGFloat? = nil) {
        self.color = color ?? .white
        self.navigationBar.tintColor = tintColor ?? .black
        self.hideBottomNavigationLine = hideBottomHairline ?? false
        self.contentHeight = contentHeight
        self.isTransparent = isTransparent

        adjustNavigationAlpha(scrollView: scrollView)
    }

    public func contentOn(scrollView: UIScrollView, navigationBar: Bool? = nil, statusBar: Bool? = nil) {
        let offset: CGFloat = {
            let navBarHeight = self.navigationBar.frame.size.height
            let statusBarHeight = UIApplication.shared.statusBarFrame.size.height

            if navigationBar == nil, statusBar == nil {
                return 0
            }

            let offset: CGFloat = {
                if navigationBar == nil, statusBar != nil {
                    fatalError("Setting Top ContentOffset only for Status bar is not allwed.")
                } else if navigationBar != nil, statusBar == nil {
                    return navBarHeight
                } else {
                    return navBarHeight + statusBarHeight
                }
            }()
            return offset
        }()

        scrollView.contentInset.top = offset * -1

        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
    }
}

extension GlassNavigationController: UIScrollViewDelegate {

    func adjustNavigationAlpha(scrollView: UIScrollView) {
        let maxHeight = contentHeight ?? scrollView.contentSize.height

        let alpha: CGFloat = {
            if let maxHeight = contentHeight {
                return scrollView.contentOffset.y / maxHeight
            }
            return scrollView.contentOffset.y / (maxHeight - scrollView.frame.size.height)
        }()

        let contentInsetTop = scrollView.contentInset.top * -1

        if scrollView.contentOffset.y > contentInsetTop {
            scrollingBackground(color: self.color.withAlphaComponent(alpha >= 1.0 ? 1.0 : alpha),
                                isTranslucent: alpha < 1.0)
        } else {
            scrollingBackground(color: self.color.withAlphaComponent(0.0), isTranslucent: true)
        }
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustNavigationAlpha(scrollView: scrollView)
    }

    func scrollingBackground(color: UIColor, isTranslucent: Bool) {
        setBackground(color: color)
        self.navigationBar.isTranslucent = isTranslucent
    }
}

extension GlassNavigationController {
    public func setBackground(color: UIColor) {
        self.navigationBar.setBackgroundImage(setImageFrom(color: color), for: UIBarMetrics.default)
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

    func setTransparent(_ isTransParent: Bool) {
        if isTransParent {
            self.navigationBar.isTranslucent = true
            self.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationBar.shadowImage = UIImage()
        } else {
            let background = setImageFrom(color: self.color.withAlphaComponent(self.navigationBar.alpha))
            self.navigationBar.setBackgroundImage(background, for: .default)
        }
    }

    public func setNavBarToDefault(scrollView: UIScrollView) {
        self.setNavbarTheme(scrollView: scrollView, isTransparent: true, color: .white, tintColor: nil,
                            hideBottomHairline: false, contentHeight: nil)
        self.navigationBar.shadowImage = nil
        self.navigationBar.alpha = 1.0
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
