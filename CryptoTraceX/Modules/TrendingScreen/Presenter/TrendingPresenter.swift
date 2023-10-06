//
//  TrendingPresenter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

protocol TrendingPresenterProtocol: AnyObject {
    
    func getTrendingCryptos()
    func routeToDetailScreen(coin: String)
}

final class TrendingPresenter: TrendingPresenterProtocol {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Text {
            static let alertActionText: String = "Retry"
        }
    }
    
    // MARK: - Private Properties
    
    private weak var viewController: TrendingViewControllerProtocol?
    private let trendingRouter: TrendingRouterProtocol
    private let networkService: APICallerProtocol
    
    // MARK: - Init
    
    init(
        viewController: TrendingViewControllerProtocol?,
        router : TrendingRouter,
        networkService : APICallerProtocol
    ) {
        self.viewController = viewController
        self.trendingRouter = router
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    func routeToDetailScreen(coin: String) {
        trendingRouter.showDetailScreen(coinName: coin)
    }
    
    func getTrendingCryptos() {
        guard let baseURL = URL(string: APIConstants.baseUrl) else {
            return
        }
        let url = URLBuilder.buildURL(
            baseURL: baseURL,
            pathComponents: APIConstants.pathTrendingComponents,
            queryParameters: nil
        )
        
        networkService.makeRequest(
            with: url,
            expecting: TrendingModel.self
        ) { result  in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let coins):
                    self?.viewController?.getCrypto(coins: [coins])
                case .failure(let error):
                    self?.viewController?.showAlertRetryRequest(
                        title: error.localizedDescription,
                        message: nil,
                        titleAction: Constants.Text.alertActionText
                    )
                }
            }
        }
    }
}

