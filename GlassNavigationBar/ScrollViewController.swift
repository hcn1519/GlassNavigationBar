//
//  ScrollViewController.swift
//  GlassNavigationBar
//
//  Created by 홍창남 on 2018. 5. 20..
//  Copyright © 2018년 홍창남. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }

        topButton.layer.cornerRadius = 8.0
        bottomButton.layer.cornerRadius = 8.0
        
        scrollView.delegate = self
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.extendedLayoutIncludesOpaqueBars(self)
            navbarController.contentOn(scrollView: scrollView)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavbar()
    }

    func setNavbar() {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.setNavbarTheme(scrollView: scrollView, isTransparent: true, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                            tintColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), hideBottomHairline: true, contentHeight: 500)
            navbarController.setTitleColor(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }

    @IBAction func topBtnTapped(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0, y: -1), animated: true)
    }
    
    @IBAction func bottomBtnTapped(_ sender: UIButton) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }
}

extension ScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.scrollViewDidScroll(scrollView)
        }
    }
}
