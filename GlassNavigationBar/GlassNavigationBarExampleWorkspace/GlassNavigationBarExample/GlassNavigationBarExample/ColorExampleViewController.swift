//
//  ColorExampleViewController.swift
//  GlassNavigationBarExample
//
//  Created by Seong ho Hong on 2018. 7. 14..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import Foundation
import UIKit
import GlassNavigationBar

class ColorExampleViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.extendedLayoutIncludesOpaqueBars(self, scrollView: scrollView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        setNavbar()
    }
    
    private func setNavbar() {
        if let navbarController = self.navigationController as? GlassNavigationController {
            
            let options = NavigationOptions(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), tintColor: #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), hideBottomHairline: true, contentHeight: 625)
            
            navbarController.setNavigationTheme(isTransparent: false, scrollView: scrollView, options: options)
            
            navbarController.tintColorSet = (#colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1), .white)
            navbarController.backgroundColorSet = (.white, #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1))
        }
    }
}
extension ColorExampleViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.scrollViewDidScroll(scrollView)
            
            UIApplication.shared.statusBarStyle = scrollView.contentOffset.y >= 500 ? .lightContent : .default
        }
    }
}

