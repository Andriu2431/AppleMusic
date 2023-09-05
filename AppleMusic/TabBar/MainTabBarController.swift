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
    private var trackDetailView: TrackDetailView?
    private var minimizedTopAnchorConstraint: NSLayoutConstraint!
    private var maximizedTopAnchorConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617619, alpha: 1)
        tabBar.backgroundColor = #colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)
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
    
    private func setupTrackDetailView() {
        guard let trackDetailView = trackDetailView else { return }
        
        trackDetailView.tabBarDelegate = self
        trackDetailView.delegate = storyboardSearchVC
        
        // вставляємо під tabBar
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor)
        minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        
        trackDetailView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
}

extension MainTabBarController: MainTabBarControllerDelegate {

    func minimizeTrackDetailController() {
        maximizedTopAnchorConstraint.isActive = false
        minimizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 1
            self.trackDetailView?.miniTrackView.alpha = 1
            self.trackDetailView?.maximizedStackView.alpha = 0
        })
    }
    
    func maximizeTrackDetailController(viewModel: TrackDetailViewModelProtocol) {
        if trackDetailView == nil {
            trackDetailView = TrackDetailView.loadFromNib()
            setupTrackDetailView()
        }
        
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
            self.tabBar.alpha = 0
            self.trackDetailView?.miniTrackView.alpha = 0
            self.trackDetailView?.maximizedStackView.alpha = 1
        })
        
        self.trackDetailView?.viewModel = viewModel
    }

}
