//
//  DetailPresenter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    
    func getDetailInfo()
}


final class DetailPresenter: DetailPresenterProtocol {
    
    // MARK: - Private Properties
    
    private weak var view: DetailViewControllerProtocol?
    private let networkService: APICallerProtocol
    private var coinName: String
    
    // MARK: - Init
    
    init(view: DetailViewControllerProtocol,
         networkService: APICallerProtocol,
         coinName: String
    ) {
        self.view = view
        self.networkService = networkService
        self.coinName = coinName
    }
    
    // MARK: - Methods
    
    func getDetailInfo() {
        var pathDetailedComponent = APIConstants.pathDetailedComponents
        pathDetailedComponent.append(coinName.lowercased())
        guard let baseURL = URL(string: APIConstants.baseUrl) else {
            return
        }
        let url = URLBuilder.buildURL(
            baseURL: baseURL,
            pathComponents: pathDetailedComponent,
            queryParameters: nil
        )
        networkService.makeRequest(with: url, expecting: CoinDetailModel.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coin):
                    self.view?.getDetailInfo(coin: coin, coinNameID: self.coinName)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
