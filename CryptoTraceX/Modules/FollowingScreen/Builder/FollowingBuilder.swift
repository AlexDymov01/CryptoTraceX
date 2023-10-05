//
//  FollowingBuilder.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation
import UIKit

final class FollowingBuilder: Presentable {
    
    func toPresent() -> UIViewController {
        let viewController = FollowingViewController()
        let networkService = APICaller()
        let router = FollowingRouter(viewController: viewController)
        let presenter = FollowingPresenter(
            view: viewController,
            networkService : networkService,
            router : router
        )
        viewController.set(presenter: presenter)
        return viewController
    }
}
