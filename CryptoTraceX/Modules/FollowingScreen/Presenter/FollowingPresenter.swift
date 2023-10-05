//
//  FollowingPresenter.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import Foundation

protocol FollowingPresenterProtocol: AnyObject {
    
    func getFollowingCoins()
    func routeToTheDetailScreen(coinName : String)
}

final class FollowingPresenter: FollowingPresenterProtocol {
    
    // MARK: - Private Properties
    
    private weak var viewController: FollowingViewControllerProtocol?
    private let networkService: APICallerProtocol
    private let router: FollowingRouterProtocol
    
    // MARK: - Init
    
    init(view: FollowingViewControllerProtocol,
         networkService: APICallerProtocol,
         router : FollowingRouterProtocol
    ) {
        self.viewController = view
        self.networkService = networkService
        self.router = router
    }
    
    // MARK: - Methods
    
    func getFollowingCoins() {
        DataPersistanceManager.shared.fetchingCoinsFromDataBase { result in
            switch result {
            case .success(let coins):
                self.viewController?.getFollowingCoins(coins: coins)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func routeToTheDetailScreen(coinName: String) {
        router.showDetailScreen(coinName: coinName)
    }
}


