//
//  CoinDetailInfoTableViewCell.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 29.09.2023.
//

import UIKit

final class CoinDetailInfoTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let leftTierStackViewSpacing: CGFloat = 50
            static let rightTierStackViewSpacing: CGFloat = 50
            static let cryptoImageViewTopOffset: CGFloat = 70
            static let cryptoImageViewLeadingTrailingInset: CGFloat = 100
            static let cryptoImageViewHeight: CGFloat = 100
            static let leftGeneralStackViewTopOffset: CGFloat = 70
            static let leftGeneralStackViewLeadingInset: CGFloat = 30
            static let leftGeneralStackViewBottomInset: CGFloat = 10
            static let rightGeneralStackViewTopOffset: CGFloat = 70
            static let rightGeneralStackViewTrailingInset: CGFloat = 30
            static let rightGeneralStackViewBottomOffset: CGFloat = 10
        }
        
        enum Text {
            static let currentPriceStackViewText: String = "Current Price"
            static let declineFromHighStackViewText: String = "Decline from High"
            static let dailyHighStackViewText: String = "24h High"
            static let rankStackViewText: String = "Rank"
            static let marketCapStackViewText: String = "Market Capitalization"
            static let dailyLowStackView: String = "24h Low"
            static let interestedCurrency: String = "usd"
        }
        
    }
    
    // MARK: - Private Properties
    
    private lazy var cryptoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var leftGeneralStackView: UIStackView = {
        let stackView = UIStackView()
        [
            currentPriceStackView,
            declineFromHighStackView,
            dailyHighStackView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.leftTierStackViewSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var rightGeneralStackView: UIStackView = {
        let stackView = UIStackView()
        [
            rankStackView,
            marketCapStackView,
            dailyLowStackView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.rightTierStackViewSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var currentPriceStackView = CryptoDataView(
        title: Constants.Text.currentPriceStackViewText,
        purpose: .detailScreen
    )
    private lazy var declineFromHighStackView = CryptoDataView(
        title: Constants.Text.declineFromHighStackViewText,
        purpose: .detailScreen
    )
    private lazy var dailyHighStackView = CryptoDataView(
        title: Constants.Text.dailyHighStackViewText,
        purpose: .detailScreen
    )
    private lazy var rankStackView = CryptoDataView(
        title: Constants.Text.rankStackViewText,
        purpose: .detailScreen
    )
    private lazy var marketCapStackView = CryptoDataView(
        title: Constants.Text.marketCapStackViewText,
        purpose: .detailScreen
    )
    private lazy var dailyLowStackView = CryptoDataView(
        title: Constants.Text.dailyLowStackView,
        purpose: .detailScreen
    )
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [
            cryptoImageView,
            leftGeneralStackView,
            rightGeneralStackView
        ].forEach { subview in
            contentView.addSubview(subview)
        }
        selectionStyle = .none
    }
    
    private func addConstraints() {
        cryptoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Layout.cryptoImageViewTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.Layout.cryptoImageViewLeadingTrailingInset)
            make.height.equalTo(Constants.Layout.cryptoImageViewHeight)
        }
        
        leftGeneralStackView.snp.makeConstraints { make in
            make.top.equalTo(cryptoImageView.snp.bottom).offset(Constants.Layout.leftGeneralStackViewTopOffset)
            make.leading.equalToSuperview().inset(Constants.Layout.leftGeneralStackViewLeadingInset)
            make.bottom.equalToSuperview().inset(Constants.Layout.leftGeneralStackViewBottomInset)
        }
        
        rightGeneralStackView.snp.makeConstraints { make in
            make.top.equalTo(cryptoImageView.snp.bottom).offset(Constants.Layout.rightGeneralStackViewTopOffset)
            make.trailing.equalToSuperview().inset(Constants.Layout.rightGeneralStackViewTrailingInset)
            make.bottom.equalToSuperview().inset(Constants.Layout.rightGeneralStackViewBottomOffset)
        }
    }
    
    // MARK: - Methods
    
    func configure(with model : CoinDetailModel) {
        guard let url = URL(string: model.image.large) else {
            return
        }
        cryptoImageView.sd_setImage(with: url, completed: nil)
        
        let inUsd = Constants.Text.interestedCurrency
        
        currentPriceStackView.setData(
            value: model.marketData.currentPrice[inUsd] ?? .zero,
            dataType: .currency
        )
        declineFromHighStackView.setData(
            value: model.marketData.athChangePercentage[inUsd] ?? .zero,
            dataType: .percent
        )
        dailyHighStackView.setData(
            value: model.marketData.high24H[inUsd] ?? .zero,
            dataType: .currency
        )
        dailyLowStackView.setData(
            value: model.marketData.low24H[inUsd] ?? .zero,
            dataType: .currency
        )
        rankStackView.setData(
            value: Double(model.marketCapRank),
            dataType: .industryRank
        )
        marketCapStackView.setData(
            value: model.marketData.marketCap[inUsd] ?? .zero,
            dataType: .currency
        )
    }
}

