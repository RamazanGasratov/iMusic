//
//  MainTabBarController.swift
//  IMusic
//
//  Created by macbook on 22.06.2023.
//

import UIKit
import SwiftUI

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizedTrackDetailController()
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    private var minimizedTopAnchorConstraints: NSLayoutConstraint!
    private var maximizedTopAnchorConstraints: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.280652225, blue: 0.405890584, alpha: 1)
      
        searchVC.tabBarDelegate = self
        
        let libraryVC = Library()
        let hostVC = UIHostingController(rootView: libraryVC)
        hostVC.tabBarItem.image = UIImage(named: "library")
        hostVC.tabBarItem.title = "Library"
        
        
        viewControllers = [
            hostVC,
            generateViewController(rootViewController: searchVC, image: UIImage(named: "search")!, title: "Search")
        ]
        
        setupTrackDetailView()
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    private func setupTrackDetailView() {
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        //use auto layout
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        maximizedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraints = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        maximizedTopAnchorConstraints.isActive = true
//        trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {
    
    func maximizedTrackDetailController(viewModel: SearchViewModel.Cell?) {
        minimizedTopAnchorConstraints.isActive = false
        maximizedTopAnchorConstraints.isActive = true
        maximizedTopAnchorConstraints.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView.miniTrackView.alpha = 0
            self.trackDetailView.mixizedStackView.alpha = 1
        }
        guard let viewModel = viewModel else {return}
        self.trackDetailView.set(viewModel: viewModel)
    }
    
    func minimizedTrackDetailController() {
        maximizedTopAnchorConstraints.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraints.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut) {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView.miniTrackView.alpha = 1
            self.trackDetailView.mixizedStackView.alpha = 0
        }
    }
}
