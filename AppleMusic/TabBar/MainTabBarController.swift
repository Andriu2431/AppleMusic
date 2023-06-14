//
//  MainTabBarController.swift
//  AppleMusic
//
//  Created by Andrii Malyk on 12.06.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = #colorLiteral(red: 1, green: 0.1719063818, blue: 0.4505617619, alpha: 1)
        
        let storyboardSearchVC: SearchMusicViewController = SearchMusicViewController.loadFromStoryboard()
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
}
