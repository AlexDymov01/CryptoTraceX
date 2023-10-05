//
//  DetailBuilder.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit

final class DetailBuilder: Presentable {
    
    // MARK: - Private Properties

    private let coinName: String
    
    // MARK: - Init
    
    init(coinName: String) {
        self.coinName = coinName
    }
    
    // MARK: - Methods
    
    func toPresent() -> UIViewController {
        let viewController = DetailViewController()
        let networkManager = APICaller()
        let presenter = DetailPresenter(
            view: viewController,
            networkService: networkManager,
            coinName: coinName
        )
        viewController.set(presenter: presenter)
        return viewController
    }
}
