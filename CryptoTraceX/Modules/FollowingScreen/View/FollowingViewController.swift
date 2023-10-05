//
//  FollowingViewController.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit
import SnapKit

protocol FollowingViewControllerProtocol: AnyObject {
    
    func getFollowingCoins(coins : [CoinItem])
}

final class FollowingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let headerViewDynamicOffset: CGFloat = 0.125
            static let tableViewHeaderViewHeight: CGFloat = 20
            static let tableViewTopOffset : CGFloat = 30
            static let tableViewCellHeight : CGFloat = 100
        }
        
        enum Text {
            static let navigationTitleText: String = "Your Watchlist"
            static let backButtonText: String = "Back"
            static let savedNotification : String = "saved"
            static let deletedNotification : String = "deleted"
            static let emptyText : String = ""
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var followingCoinsTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            SimplifiedTableViewCell.self,
            forCellReuseIdentifier: String(describing: SimplifiedTableViewCell.self)
        )
        return tableView
    }()
    
    private lazy var tableViewHeaderView = CoinHeaderView(
        frame: .zero,
        shouldShowPriceLabel: false,
        shouldShowReloadButton: false
    )
    
    // MARK: - Properties
    
    private var followingCoins: [CoinItem] = [CoinItem]()
    private var presenter: FollowingPresenterProtocol?
    
    // MARK: - Dynamic Constraints
    
    private var dynamicOffsetForHeaderView: CGFloat {
        view.bounds.height * Constants.Layout.headerViewDynamicOffset
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureNavBar()
        addConstraints()
        fetchData()
        addObservers()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [
            followingCoinsTableView,
            tableViewHeaderView,
        ].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .black
    }
    
    private func fetchData() {
        presenter?.getFollowingCoins()
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
    
    private func addObservers() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(Constants.Text.savedNotification),
            object: nil,
            queue:  nil
        ) { _ in
            self.presenter?.getFollowingCoins()
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name(Constants.Text.deletedNotification),
            object: nil,
            queue:  nil
        ) { _ in
            self.presenter?.getFollowingCoins()
        }
    }
    
    private func addConstraints() {
        tableViewHeaderView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(dynamicOffsetForHeaderView)
            make.height.equalTo(Constants.Layout.tableViewHeaderViewHeight)
        }
        
        followingCoinsTableView.snp.makeConstraints { make in
            make.top.equalTo(tableViewHeaderView).offset(Constants.Layout.tableViewTopOffset)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - TableViewDelegate & TableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followingCoins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Layout.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell  = tableView.dequeueReusableCell(
            withIdentifier: String(describing: SimplifiedTableViewCell.self),
            for: indexPath
        ) as? SimplifiedTableViewCell else {
            return UITableViewCell()
        }
        let coin = followingCoins[indexPath.row]
        let emptyText = Constants.Text.emptyText
        cell.configure(
            with: Item(
                id: coin.id ?? emptyText,
                name: coin.name ?? emptyText ,
                large: coin.large ?? emptyText
            ),
            id: indexPath.row
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let coin = followingCoins[indexPath.row]
        self.presenter?.routeToTheDetailScreen(coinName: coin.id ?? Constants.Text.emptyText)
    }
    
    // MARK: - Injection
    
    func set(presenter: FollowingPresenterProtocol?) {
        self.presenter = presenter
    }
}

// MARK: - OverviewViewControllerProtocol

extension FollowingViewController: FollowingViewControllerProtocol {
    func getFollowingCoins(coins: [CoinItem]) {
        self.followingCoins = coins
        self.followingCoinsTableView.reloadData()
    }
}





