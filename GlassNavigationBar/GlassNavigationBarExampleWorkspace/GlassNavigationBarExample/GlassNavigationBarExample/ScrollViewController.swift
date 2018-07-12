//
//  ScrollViewController.swift
//  GlassNavigationBarExample
//
//  Created by Seong ho Hong on 2018. 7. 12..
//  Copyright © 2018년 Seong ho Hong. All rights reserved.
//

import UIKit
import GlassNavigationBar

class ScrollViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.extendedLayoutIncludesOpaqueBars(self, scrollView: scrollView)
            navbarController.scrollViewAboveNavigation(scrollView: scrollView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        setNavbar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.setTitleColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func setNavbar() {
        if let navbarController = self.navigationController as? GlassNavigationController {
            UIApplication.shared.statusBarStyle = .default
            
            let options = NavigationOptions(backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), hideBottomHairline: true, contentHeight: 600)
            navbarController.setNavigationTheme(isTransparent: false, scrollView: scrollView, options: options)
        }
    }
}

extension ScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.scrollViewDidScroll(scrollView)
        }
    }
}
