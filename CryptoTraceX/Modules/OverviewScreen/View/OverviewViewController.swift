//
//  OverviewViewController.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit
import SnapKit

protocol OverviewViewControllerProtocol: AnyObject {
    
    func getGlobalData(globalData: OverviewGlobalData)
    func getCryptos(cryptos: [OverviewTableViewCoin])
    func getExchanges(exchanges: [OverviewCollectionViewExchange])
    
    func showAlertRetryRequest(title: String, message: String?, titleAction: String)
}

final class OverviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, OverviewViewControllerProtocol {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let itemWidth: CGFloat = 255
            static let itemHeight: CGFloat = 140
            static let marketDataStackViewSpacing: CGFloat = 40
            static let marketDataStackViewCustomSpacing: CGFloat = 0.08
            static let marketDataStackViewTopOffset: CGFloat = 0.125
            static let marketDataStackViewSidesInset: CGFloat = 0.04
            static let overViewCollectionViewHeight: CGFloat = 150
            static let overViewCollectionViewTopOffset: CGFloat = 20
            static let overViewCollectionViewSidesInset: CGFloat = 10
            static let overViewTableViewHeaderViewTopOffset: CGFloat = 15
            static let overViewTableViewHeaderViewHeight: CGFloat = 20
            static let overViewTableViewTopOffset: CGFloat = 25
            static let overViewCollectionViewMinimumLineSpacing: CGFloat = 20
            static let alertControllerCornerRadius: CGFloat = 10
        }
        
        enum Text {
            static let marketCapStackViewTitle: String = "Market Cap"
            static let btcDominanceStackViewTitle: String = "BTC Dominance"
            static let dailyMarketVolumeStackViewTitle: String = "Daily Volume"
            static let navigationItemTitle: String = "CryptoTraceX"
            static let infoAlertControllerTitle: String = "Warning"
            static let infoAlertControllerActionTitle: String = "Ok"
            static let backButtonTitle: String = "Back"
            static let totalMarketCapValueText: String = "usd"
            static let marketCapPercentageText: String = "btc"
            static let totalVolumeText: String = "usd"
            static let infoAlertControllerMessage: String = """
                                                        The information provided here is for informational purposes only.
                                                        Financial decisions should be made with caution.
                                                        """
        }
        
        enum Value {
            static let totalMarketCapDefaultValue: Double = 23232.0
            static let marketCapPercentageDefaultValue: Double = 32.4
            static let totalVolumeDefaultValue: Double = 232344232.0
        }
        
        enum Image {
            static let infoButton: String = "info.circle.fill"
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var overviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            MainTableViewCell.self,
            forCellReuseIdentifier: String(describing: MainTableViewCell.self)
        )
        return tableView
    }()
    
    private lazy var overviewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: Constants.Layout.itemWidth,
            height: Constants.Layout.itemHeight
        )
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            ExchangeCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: ExchangeCollectionViewCell.self)
        )
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private lazy var marketCapStackView = CryptoDataView(
        title: Constants.Text.marketCapStackViewTitle,
        purpose: .mainScreen
    )
    private lazy var btcDominanceStackView = CryptoDataView(
        title: Constants.Text.btcDominanceStackViewTitle,
        purpose: .mainScreen
    )
    private lazy var dailyMarketVolumeStackView = CryptoDataView(
        title: Constants.Text.dailyMarketVolumeStackViewTitle,
        purpose: .mainScreen
    )
    
    private lazy var marketDataStackView: UIStackView = {
        let stackView = UIStackView()
        [
            marketCapStackView,
            dailyMarketVolumeStackView,
            btcDominanceStackView
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.marketDataStackViewSpacing
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.setCustomSpacing(
            marketDataStackViewCustomSpacing,
            after: dailyMarketVolumeStackView
        )
        return stackView
    }()
    
    private lazy var overviewTableViewHeaderView = CoinHeaderView(
        frame: .zero,
        shouldShowPriceLabel: true,
        shouldShowReloadButton: true
    )
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    // MARK: - Properties
    
    private var presenter: OverviewPresenterProtocol?
    private var globalData: OverviewGlobalData?
    private var exchanges = [OverviewCollectionViewExchange]()
    private var cryptos = [OverviewTableViewCoin]()
    
    // MARK: - Dynamic Constraints
    
    private var marketDataStackViewTopOffset : CGFloat {
        view.bounds.height * Constants.Layout.marketDataStackViewTopOffset
    }
    
    private var marketDataStackViewSidesInset : CGFloat {
        view.bounds.width * Constants.Layout.marketDataStackViewSidesInset
    }
    
    private var marketDataStackViewCustomSpacing : CGFloat {
        view.bounds.width * Constants.Layout.marketDataStackViewCustomSpacing
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        applyConstraints()
        configureNavBar()
        activityIndicator.startAnimating()
        fetchData()
        tableViewHeaderViewReload()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [
            overviewTableView,
            overviewTableViewHeaderView,
            marketDataStackView,
            overviewCollectionView,
            activityIndicator
        ].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .black
    }
    
    private func fetchData() {
        presenter?.getCryptos()
        presenter?.getExchanges()
        presenter?.getGlobalData()
    }
    
    private func tableViewHeaderViewReload() {
        overviewTableViewHeaderView.completionHandler = {
            self.activityIndicator.startAnimating()
            self.fetchData()
        }
    }
    
    private func applyConstraints() {
        marketDataStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(marketDataStackViewTopOffset)
            make.leading.trailing.equalToSuperview().inset(marketDataStackViewSidesInset)
        }
        
        overviewCollectionView.snp.makeConstraints { make in
            make.height.equalTo(Constants.Layout.overViewCollectionViewHeight)
            make.top.equalTo(marketDataStackView.snp.bottom).offset(
                Constants.Layout.overViewCollectionViewTopOffset
            )
            make.leading.trailing.equalToSuperview().inset(Constants.Layout.overViewCollectionViewSidesInset)
        }
        
        overviewTableViewHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(overviewCollectionView.snp.bottom).offset(
                Constants.Layout.overViewTableViewHeaderViewTopOffset
            )
            make.height.equalTo(Constants.Layout.overViewTableViewHeaderViewHeight)
        }
        
        overviewTableView.snp.makeConstraints { make in
            make.top.equalTo(overviewTableViewHeaderView).offset(Constants.Layout.overViewTableViewTopOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureNavBar() {
        self.navigationItem.title = Constants.Text.navigationItemTitle
        let backButton = UIBarButtonItem(
            title: Constants.Text.backButtonTitle,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backButton
        backButton.tintColor = .white
        let infoButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.Image.infoButton),
            style: .done,
            target: self,
            action: #selector(showCustomAlert)
        )
        navigationItem.rightBarButtonItem = infoButton
        infoButton.tintColor = .white
    }
    
    private func showAlertInfo(title: String, message: String?, titleAction: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let customAction = UIAlertAction(title: titleAction, style: .cancel)
        alertController.addAction(customAction)
        alertController.view.tintColor = UIColor.white
        alertController.view.backgroundColor = UIColor.black
        alertController.view.layer.cornerRadius = Constants.Layout.alertControllerCornerRadius
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func showCustomAlert(sender : UIButton) {
        showAlertInfo(title: Constants.Text.infoAlertControllerTitle,
                      message: Constants.Text.infoAlertControllerMessage,
                      titleAction: Constants.Text.infoAlertControllerActionTitle
        )
    }
    
    // MARK: - Injection
    
    func set(presenter: OverviewPresenterProtocol?) {
        self.presenter = presenter
    }
    
    // MARK: - TableViewDelegate & TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MainTableViewCell.self),
            for: indexPath
        ) as? MainTableViewCell else {
            return UITableViewCell()
        }
        
        let coin = cryptos[indexPath.row]
        cell.configure(with: coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = cryptos[indexPath.row]
        presenter?.routeToDetailScreen(coinName: coin.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    // MARK: - CollectionViewDeleate & CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exchanges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: ExchangeCollectionViewCell.self),
            for: indexPath
        ) as? ExchangeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let exchange = exchanges[indexPath.row]
        cell.configure(with: exchange)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = exchanges[indexPath.row].url
        presenter?.routeToWebSite(url: url)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constants.Layout.overViewCollectionViewMinimumLineSpacing
    }

    // MARK: - OverviewViewControllerProtocol
    
    func getGlobalData(globalData: OverviewGlobalData) {
        self.globalData = globalData
        marketCapStackView.setData(
            value: globalData.data?.totalMarketCap[Constants.Text.totalMarketCapValueText] ??
            Constants.Value.totalMarketCapDefaultValue,
            dataType: .currency
        )
        btcDominanceStackView.setData(
            value: globalData.data?.marketCapPercentage[Constants.Text.marketCapPercentageText] ??
            Constants.Value.marketCapPercentageDefaultValue,
            dataType: .percent
        )
        dailyMarketVolumeStackView.setData(
            value: globalData.data?.totalVolume[Constants.Text.totalVolumeText] ??
            Constants.Value.totalVolumeDefaultValue,
            dataType: .currency
        )
    }
    
    func getCryptos(cryptos: [OverviewTableViewCoin]) {
        self.cryptos = cryptos
        overviewTableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func getExchanges(exchanges: [OverviewCollectionViewExchange]) {
        self.exchanges = exchanges
        overviewCollectionView.reloadData()
    }
    
    func showAlertRetryRequest(title: String, message: String?, titleAction: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let customAction = UIAlertAction(title: titleAction, style: .default) { _ in
            self.fetchData()
        }
        alertController.addAction(customAction)
        alertController.view.tintColor = UIColor.white
        alertController.view.backgroundColor = UIColor.black
        alertController.view.layer.cornerRadius = Constants.Layout.alertControllerCornerRadius
        self.present(alertController, animated: true, completion: nil)
    }
}
