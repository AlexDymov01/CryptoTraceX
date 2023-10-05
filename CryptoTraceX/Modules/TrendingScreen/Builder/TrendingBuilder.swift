//
//  TrendingBuilder.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

final class TrendingBuilder: Presentable{
    
    func toPresent() -> UIViewController {
        let viewController = TrendingViewController()
        let networkManager = APICaller()
        let router = TrendingRouter(viewController: viewController)
        let presenter = TrendingPresenter(
            viewController: viewController,
            router: router,
            networkService: networkManager
        )
        viewController.set(presenter: presenter)
        return viewController
    }
}
