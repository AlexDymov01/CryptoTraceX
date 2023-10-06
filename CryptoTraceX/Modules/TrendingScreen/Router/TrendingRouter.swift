//
//  TrendingRouter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

protocol TrendingRouterProtocol: AnyObject {
    
    func showDetailScreen(coinName: String)
}

final class TrendingRouter: TrendingRouterProtocol {
    
    // MARK: - Private Properties
    
    private var trendingController: UIViewController?
    
    // MARK: - Init
    
    init(viewController: UIViewController) {
        self.trendingController = viewController
    }
    
    // MARK: - Methods
    
    func showDetailScreen(coinName: String) {
        let detailViewController = DetailBuilder(coinName: coinName).toPresent()
        detailViewController.modalPresentationStyle = .fullScreen
        trendingController?.show(detailViewController, sender: nil)
    }
}
