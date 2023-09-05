//
//  MainTabBarController.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 12.06.2023.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func minimizeTrackDetailController()
    func maximizeTrackDetailController(viewModel: TrackDetailViewModelProtocol)
}

class MainTabBarController: UITabBarController {
    
    private let storyboardSearchVC: SearchMusicViewController = SearchMusicViewController.loadFromStoryboard()
    private let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617619, alpha: 1)
        tabBar.backgroundColor = .white
        setupTrackDetainView()
        storyboardSearchVC.tabBarDelegate = self
        
        let storyboardLibraryVC: LibraryMusicViewController = LibraryMusicViewController.loadFromStoryboard()
        let searchVC = createNavigationVC(rootVC: storyboardSearchVC, title: "Search", image: #imageLiteral(resourceName: "search"))
        let libraryVC = createNavigationVC(rootVC: storyboardLibraryVC, title: "Library", image: #imageLiteral(resourceName: "library"))
        viewControllers = [searchVC, libraryVC]
    }
    
    private func createNavigationVC(rootVC: UIViewController, title: String, image: UIImage) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: rootVC)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        rootVC.navigationItem.title = title
        navigationVC.navigationBar.prefersLargeTitles = true
        
        return navigationVC
    }
    
    private func setupTrackDetainView() {
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = storyboardSearchVC
        
        // вставляємо під tabBar
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.isActive = true
        
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {

    func minimizeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
        })
    }
    
    func maximizeTrackDetailController(viewModel: TrackDetailViewModelProtocol) {
        maximizedTopAnchorConstraint.isActive = true
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
        })
        
        self.trackDetailView.viewModel = viewModel
    }

}
