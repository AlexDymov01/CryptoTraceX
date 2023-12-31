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
    func showAlertRetryRequest(title: String, message: String?, titleAction: String)
}

final class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DetailViewControllerProtocol {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let numberOfRowsInSection: CGFloat = 2
            static let alertControllerCornerRadius : CGFloat = 20
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
        rightBarButtonItem.action = #selector(saveToTheFollowing(sender:))
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
    
    @objc private func saveToTheFollowing(sender: UIBarButtonItem) {
        guard let coin = coin  else { return }
        
        presenter?.isCoinSaved(withName: coin.name) { isCoinSaved in
            if isCoinSaved {
                self.presenter?.deleteCoinItem(withName: coin.name)
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.Image.unsavedImage)
            } else {
                self.presenter?.saveToTheDataBase(coin: coin, id: self.coinID ?? Constants.Text.emptyText)
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: Constants.Image.savedImage)
            }
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
    
    // MARK: - DetailViewControllerProtocol
    
    func getDetailInfo(coin: CoinDetailModel, coinNameID: String) {
        self.coin = coin
        self.coinID = coinNameID
        self.title = coin.name
        cryptoDetailsTableView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    func showAlertRetryRequest(title: String, message: String?, titleAction: String) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let customAction = UIAlertAction(title: titleAction, style: .default) { _ in
            self.presenter?.getDetailInfo()
        }
        alertController.addAction(customAction)
        alertController.view.tintColor = UIColor.white
        alertController.view.backgroundColor = UIColor.black
        alertController.view.layer.cornerRadius = Constants.Layout.alertControllerCornerRadius
        self.present(alertController, animated: true, completion: nil)
    }
}
