//
//  TrendingViewController.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit
import SnapKit

protocol TrendingViewControllerProtocol: AnyObject {
    
    func getCrypto(coins : [TrendingModel])
    func showAlertRetryRequest(title: String, message: String?, titleAction: String)
}

final class TrendingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TrendingViewControllerProtocol {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let headerViewDynamicOffset: CGFloat = 0.125
            static let trendingTableViewHeaderViewHeight: CGFloat = 20
            static let trendingCryptoTableViewTopOffset: CGFloat = 30
            static let trendingCryptoTableViewCellHeight = 100
            static let alertControllerCornerRadius: CGFloat = 20
        }
        
        enum Text {
            static let navigationTitleText: String = "24-Hour Trending Coins"
            static let backButtonText: String = "Back"
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var trendingTableViewHeaderView = CoinHeaderView(
        frame: .zero,
        shouldShowPriceLabel: false,
        shouldShowReloadButton: true
    )
    
    private lazy var trendingCryptoTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SimplifiedTableViewCell.self,
            forCellReuseIdentifier: String(describing: SimplifiedTableViewCell.self)
        )
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    // MARK: - Properties
    
    private var presenter: TrendingPresenterProtocol?
    private var cryptos = [TrendingModel]()
    
    // MARK: - Dynamic Constraints
    
    private var dynamicOffsetForHeaderView : CGFloat {
        view.bounds.height * Constants.Layout.headerViewDynamicOffset
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        configureNavBar()
        activityIndicator.startAnimating()
        fetchData()
        trendingTableViewHeaderViewReload()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [
            trendingCryptoTableView,
            trendingTableViewHeaderView,
            activityIndicator,
        ].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .black
    }
    
    private func fetchData() {
        presenter?.getTrendingCryptos()
    }
    
    private func trendingTableViewHeaderViewReload() {
        trendingTableViewHeaderView.completionHandler = {
            self.activityIndicator.startAnimating()
            self.fetchData()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func configureNavBar() {
        self.navigationItem.title = Constants.Text.navigationTitleText
        let backButton = UIBarButtonItem(
            title: Constants.Text.backButtonText,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backButton
        backButton.tintColor = .white
    }
    
    private func addConstraints() {
        trendingTableViewHeaderView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(dynamicOffsetForHeaderView)
            make.height.equalTo(Constants.Layout.trendingTableViewHeaderViewHeight)
        }
        
        trendingCryptoTableView.snp.makeConstraints { make in
            make.top.equalTo(trendingTableViewHeaderView).offset(Constants.Layout.trendingCryptoTableViewTopOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - TableViewDelegate & TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !cryptos.isEmpty {
            let trendingModel = cryptos.first!
            return trendingModel.coins.count
        }
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SimplifiedTableViewCell.self),
            for: indexPath
        ) as? SimplifiedTableViewCell else {
            return UITableViewCell()
        }
        
        guard let trendingModel = cryptos[.zero].coins[indexPath.row].item else {
            return UITableViewCell()
        }
        cell.configure(with: trendingModel, id: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(Constants.Layout.trendingCryptoTableViewCellHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let coin = cryptos[.zero].coins[indexPath.row].item else {
            return
        }
        presenter?.routeToDetailScreen(coin: coin.id)
    }
    
    // MARK: - Injection
    
    func set(presenter: TrendingPresenterProtocol?) {
        self.presenter = presenter
    }
    
    // MARK: - TrendingViewControllerProtocol
    
    func getCrypto(coins: [TrendingModel]) {
        self.cryptos = coins
        trendingCryptoTableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func showAlertRetryRequest(title: String, message: String?, titleAction: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let customAction = UIAlertAction(title: titleAction, style: .default) { _ in
            self.presenter?.getTrendingCryptos()
        }
        alertController.addAction(customAction)
        alertController.view.tintColor = UIColor.white
        alertController.view.backgroundColor = UIColor.black
        alertController.view.layer.cornerRadius = Constants.Layout.alertControllerCornerRadius
        self.present(alertController, animated: true, completion: nil)
    }
}
