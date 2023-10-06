//
//  OverviewRouter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

protocol OverviewRouterProtocol: AnyObject {
    
    func showDetaileScreen(coinName: String)
    func showWebsite(url: String)
}

final class OverviewRouter: OverviewRouterProtocol {
    
    // MARK: - Private Properties
    
    private var overviewController: UIViewController?
    
    // MARK: - Initializer
    
    init(viewController: UIViewController) {
        self.overviewController = viewController
    }
    
    // MARK: - Methods
    
    func showDetaileScreen(coinName: String) {
        let detailViewController = DetailBuilder(coinName: coinName).toPresent()
        detailViewController.modalPresentationStyle = .fullScreen
        overviewController?.show(detailViewController, sender: nil)
    }
    
    func showWebsite(url: String) {
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
}
