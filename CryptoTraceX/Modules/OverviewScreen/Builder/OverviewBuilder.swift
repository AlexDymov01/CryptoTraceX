//
//  OverviewBuilder.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

final class OverviewBuilder: Presentable {
    
    func toPresent() -> UIViewController {
        let viewController = OverviewViewController()
        let networkManager = APICaller()
        let router = OverviewRouter(viewController: viewController)
        let presenter = OverviewPresenter(
            view: viewController,
            networkService: networkManager,
            router: router
        )
        viewController.set(presenter: presenter)
        return viewController
    }
}
