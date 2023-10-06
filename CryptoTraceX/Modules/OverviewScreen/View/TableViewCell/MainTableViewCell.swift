//
//  MainTableViewCell.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 05.09.2023.
//

import UIKit
import SDWebImage

class MainTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let declarationStackViewSpacing: CGFloat = 8
            static let priceStackViewSpacing: CGFloat = 10
            static let declarationStackViewLeadingInset: CGFloat = 10
            static let priceStackViewTrailingInset: CGFloat = 10
            static let counterLabelLayout : CGFloat = 25
            static let coinImageLayout : CGFloat = 30
            static let cryptoTickerLabelWidth: CGFloat = 70
            static let cryptoTickerLabelHeight: CGFloat = 15
            static let cryptoPriceLabelHeight: CGFloat = 12
            static let cryptoPriceLabelWidth: CGFloat = 120
            static let volatilityIndicatorLabelWidth: CGFloat = 80
            static let volatilityIndicatorLabelHeight: CGFloat = 10
            
            
        }
        
        enum Text {
            static let textColorGuardPrefix: String = "-"
            static let coinCounterLabelText: String = "Coin"
            static let dollar: String = " $"
            static let formatter2f : String = "%.2f %%"
        }
        
        enum Numbers {
            static let zeroValue : Double = 0.0
        }
    }
    
    // MARK: - Private Properties
    
    private lazy var counterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var cryptoTickerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private lazy var cryptoPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private lazy var volatilityIndicatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.textColor = .green
        return label
    }()
    
    private lazy var coinImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var declarationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            counterLabel,
            coinImage,
            cryptoTickerLabel
            
        ])
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.declarationStackViewSpacing
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            cryptoPriceLabel,
            volatilityIndicatorLabel,
        ])
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.priceStackViewSpacing
        stackView.alignment = .trailing
        return stackView
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [
            declarationStackView,
            priceStackView
        ].forEach { stackView in
            addSubview(stackView)
        }
    }
    
    private func textColorGuard(text: String) {
        if text.hasPrefix(Constants.Text.textColorGuardPrefix) {
            volatilityIndicatorLabel.text = text
            volatilityIndicatorLabel.textColor = .red
        } else {
            volatilityIndicatorLabel.text = text
            volatilityIndicatorLabel.textColor = .green
        }
    }
    
    private func setupConstraints() {
        declarationStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Layout.declarationStackViewLeadingInset)
            make.centerY.equalToSuperview()
        }
        
        priceStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Constants.Layout.priceStackViewTrailingInset)
            make.centerY.equalToSuperview()
        }
        
        counterLabel.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.Layout.counterLabelLayout)
        }
        
        coinImage.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.Layout.coinImageLayout)
        }
        
        cryptoTickerLabel.snp.makeConstraints { make in
            make.width.equalTo(Constants.Layout.cryptoTickerLabelWidth)
            make.height.equalTo(Constants.Layout.cryptoTickerLabelHeight)
        }
        
        cryptoPriceLabel.snp.makeConstraints { make in
            make.width.equalTo(Constants.Layout.cryptoPriceLabelWidth)
            make.height.equalTo(Constants.Layout.cryptoPriceLabelHeight)
        }
        
        volatilityIndicatorLabel.snp.makeConstraints { make in
            make.width.equalTo(Constants.Layout.volatilityIndicatorLabelWidth)
            make.height.equalTo(Constants.Layout.volatilityIndicatorLabelHeight)
        }
    }
    
    // MARK: - Methods
    
    func configure(with model: OverviewTableViewCoin){
        counterLabel.text = String(model.marketCapRank)
        cryptoTickerLabel.text = model.symbol.uppercased()
        cryptoPriceLabel.text = String(model.currentPrice) + Constants.Text.dollar
        textColorGuard(
            text: String(
                format: Constants.Text.formatter2f,
                model.priceChangePercentage24h ?? Constants.Numbers.zeroValue
            )
        )
        guard let url = URL(string: model.image) else {
            return
        }
        coinImage.sd_setImage(with: url, completed: nil)
    }
}
