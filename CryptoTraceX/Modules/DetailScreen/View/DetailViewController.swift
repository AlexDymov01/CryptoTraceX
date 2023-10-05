//
//  DetailViewController.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 25.09.2023.
//

import UIKit
import SnapKit

protocol DetailViewControllerProtocol: AnyObject {
    
    func getDetailInfo(coin : CoinDetailModel, coinNameID: String)
}

final class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let numberOfRowsInSection: CGFloat = 2
        }
        
        enum Text {
            static let emptyText: String = ""
        }
        
        enum Image {
            static let savedImage: String = "star.fill"
            static let unsavedImage : String = "star"
        }
        
        enum Row: Int {
            case overview, description
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var cryptoDetailsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(
            CoinDetailInfoTableViewCell.self,
            forCellReuseIdentifier: String(describing: CoinDetailInfoTableViewCell.self)
        )
        tableView.register(
            DescriptionTableViewCell.self,
            forCellReuseIdentifier: String(describing: DescriptionTableViewCell.self)
        )
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    // MARK: - Properties
    
    private var presenter: DetailPresenterProtocol?
    private var coin : CoinDetailModel?
    private var coinID: String?
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setNavigationBar()
        addConstraints()
        activityIndicator.startAnimating()
        presenter?.getDetailInfo()
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [
            cryptoDetailsTableView,
            activityIndicator,
        ].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .black
    }
    
    private func setNavigationBar(){
        let rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: Constants.Image.unsavedImage),
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        rightBarButtonItem.tintColor = .white
    }
    
    private func setButtonImage(saved: Bool) {
        let imageName = saved ? Constants.Image.savedImage : Constants.Image.unsavedImage
        let image = UIImage(systemName: imageName)
        navigationItem.rightBarButtonItem?.image = image
    }
    
    private func addConstraints() {
        cryptoDetailsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - TableViewDelegate & TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Int(Constants.Layout.numberOfRowsInSection)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Constants.Row.overview.rawValue :
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: CoinDetailInfoTableViewCell.self),
                for: indexPath
            ) as? CoinDetailInfoTableViewCell else {
                return UITableViewCell()
            }
            guard let coin = coin else {
                return UITableViewCell()
            }
            cell.configure(with: coin)
            return cell
            
        case Constants.Row.description.rawValue :
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: String(describing: DescriptionTableViewCell.self),
                for: indexPath
            ) as? DescriptionTableViewCell else {
                return UITableViewCell()
            }
            guard let coin = coin else {
                return UITableViewCell()
            }
            cell.configure(with: coin)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Inversion
    
    func set(presenter: DetailPresenterProtocol?) {
        self.presenter = presenter
    }
}

// MARK: - DetailViewControllerProtocol

extension DetailViewController: DetailViewControllerProtocol {
    func getDetailInfo(coin: CoinDetailModel, coinNameID: String) {
        self.coin = coin
        self.coinID = coinNameID
        self.title = coin.name
        cryptoDetailsTableView.reloadData()
        activityIndicator.stopAnimating()
    }
}
