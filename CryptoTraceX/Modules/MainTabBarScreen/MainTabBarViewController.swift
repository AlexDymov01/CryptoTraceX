//
//  MainTabBarViewController.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 30.08.2023.

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Text {
            static let overview: String = "Overview"
            static let trending: String = "Trending"
            static let following: String = "Following"
        }
        
        enum Images {
            static let overview: UIImage? = UIImage(systemName: "house.fill")
            static let trending: UIImage? = UIImage(systemName: "chart.line.uptrend.xyaxis")
            static let following: UIImage? = UIImage(systemName: "star.fill")
        }
    }
    
    private enum TabItem: CaseIterable {
        case overview
        case trending
        case following
        
        var title: String {
            switch self {
            case .overview:
                return Constants.Text.overview
            case .trending:
                return Constants.Text.trending
            case .following:
                return Constants.Text.following
            }
        }
        
        var image: UIImage? {
            switch self {
            case .overview:
                return Constants.Images.overview
            case .trending:
                return Constants.Images.trending
            case .following:
                return Constants.Images.following
                
            }
        }
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        view.backgroundColor = .blue
    }
    
    // MARK: - Private methods
    
    private func setupTabBarItems() {
        viewControllers = TabItem.allCases.map { [weak self] tabItem in
            guard let self else {
                return UIViewController()
            }
            return self.createViewController(for: tabItem)
        }
    }
    
    
    private func setupTabBarItem(for viewController: UIViewController, title: String, image: UIImage) {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        tabBar.tintColor = .white
    }
    
    private func createViewController(for tab: TabItem) -> UIViewController {
        guard let image = tab.image else {
            fatalError("Failed to load image for MainTabBarViewController")
        }
        switch tab {
            
        case .overview:
            let overviewViewController = UINavigationController(
                rootViewController: UIViewController()
            )
            setupTabBarItem(
                for: overviewViewController,
                title: tab.title,
                image: image
            )
            return overviewViewController
            
        case .trending:
            let trendingViewController = UINavigationController(
                rootViewController: UIViewController()
            )
            setupTabBarItem(
                for: trendingViewController,
                title: tab.title,
                image: image
            )
            return trendingViewController
            
        case .following:
            let followingViewController = UINavigationController(
                rootViewController: UIViewController()
            )
            setupTabBarItem(
                for: followingViewController,
                title: tab.title,
                image: image
            )
            return followingViewController
        }
    }
}

