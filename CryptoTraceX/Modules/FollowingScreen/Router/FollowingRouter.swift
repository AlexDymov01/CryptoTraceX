//
//  FollowingRouter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

protocol FollowingRouterProtocol: AnyObject {
    
    func showDetailScreen(coinName: String)
}

final class FollowingRouter: FollowingRouterProtocol {
    
    // MARK: - Private Properties
    
    private var followingViewController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.followingViewController = viewController
    }
    
    // MARK: - Methods
    
    func showDetailScreen(coinName: String) {
        let detailViewController = DetailBuilder(coinName: coinName).toPresent()
        detailViewController.modalPresentationStyle = .fullScreen
        followingViewController?.show(detailViewController, sender: nil)
    }
}
