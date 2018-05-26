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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButton2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        topButton.layer.cornerRadius = 8.0
        bottomButton.layer.cornerRadius = 8.0
        nextButton.layer.cornerRadius = 8.0
        nextButton2.layer.cornerRadius = 8.0

        scrollView.delegate = self
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.extendedLayoutIncludesOpaqueBars(self)
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

    func setNavbar() {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.setNavbarTheme(isTransparent: true, scrollView: scrollView, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                            tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), hideBottomHairline: true, contentHeight: 600)
        }
    }

    @IBAction func topBtnTapped(_ sender: UIButton) {
        scrollView.setContentOffset(CGPoint(x: 0, y: -6), animated: true)
    }
    
    @IBAction func bottomBtnTapped(_ sender: UIButton) {
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height)
        scrollView.setContentOffset(bottomOffset, animated: true)
    }

    @IBAction func nextBtnTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToNextExample", sender: nil)
    }
}

extension ScrollViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let navbarController = self.navigationController as? GlassNavigationController {
            navbarController.scrollViewDidScroll(scrollView)
        }
    }
}
