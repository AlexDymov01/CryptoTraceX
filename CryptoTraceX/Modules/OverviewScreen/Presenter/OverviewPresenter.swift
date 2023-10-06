//
//  OverviewPresenter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

protocol OverviewPresenterProtocol: AnyObject {
    
    func getGlobalData()
    func getCryptos()
    func getExchanges()
    
    func routeToDetailScreen(coinName: String)
    func routeToWebSite(url: String)
}


final class OverviewPresenter: OverviewPresenterProtocol {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Text {
            static let alertActionText: String = "Retry"
        }
    }
    
    // MARK: - Properties
    
    private weak var view: OverviewViewControllerProtocol?
    private let router: OverviewRouterProtocol
    private let networkService : APICallerProtocol
    
    // MARK: - Init
    
    init(
        view: OverviewViewControllerProtocol,
        networkService: APICallerProtocol,
        router: OverviewRouterProtocol
    ) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    // MARK: - Methods
    
    func routeToDetailScreen(coinName: String) {
        router.showDetaileScreen(coinName: coinName)
    }
    
    func routeToWebSite(url: String) {
        router.showWebsite(url: url)
    }
    
    func getGlobalData() {
        guard let baseURL = URL(string: APIConstants.baseUrl) else {
            return
        }
        let url = URLBuilder.buildURL(
            baseURL: baseURL,
            pathComponents: APIConstants.pathGlobalComponents,
            queryParameters: nil
        )
        networkService.makeRequest(
            with: url,
            expecting: OverviewGlobalData.self
        ) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let data):
                    self?.view?.getGlobalData(globalData: data)
                case .failure(let error):
                    self?.view?.showAlertRetryRequest(
                        title: error.localizedDescription,
                        message: nil,
                        titleAction: Constants.Text.alertActionText
                    )
                }
            }
        }
    }
    
    func getCryptos() {
        guard let baseURL = URL(string: APIConstants.baseUrl) else {
            return
        }
        let url = URLBuilder.buildURL(
            baseURL: baseURL,
            pathComponents: APIConstants.pathCoinsComponents,
            queryParameters: APIConstants.coinListQueryParameters
        )
        networkService.makeRequest(
            with: url ,
            expecting: [OverviewTableViewCoin].self
        ) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let coins):
                    self?.view?.getCryptos(cryptos: coins)
                case .failure(let error):
                    self?.view?.showAlertRetryRequest(
                        title: error.localizedDescription,
                        message: nil,
                        titleAction: Constants.Text.alertActionText
                    )
                }
            }
        }
    }
    
    func getExchanges() {
        guard let baseURL = URL(string: APIConstants.baseUrl) else {
            return
        }
        let url = URLBuilder.buildURL(
            baseURL: baseURL,
            pathComponents: APIConstants.pathExchangesComponents,
            queryParameters: APIConstants.exchangesQueryParameters
        )
        networkService.makeRequest(
            with: url,
            expecting: [OverviewCollectionViewExchange].self
        ) { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let exchanges):
                    self?.view?.getExchanges(exchanges: exchanges)
                case .failure(let error):
                    self?.view?.showAlertRetryRequest(
                        title: error.localizedDescription,
                        message: nil,
                        titleAction: Constants.Text.alertActionText
                    )
                }
            }
        }
    }
}
