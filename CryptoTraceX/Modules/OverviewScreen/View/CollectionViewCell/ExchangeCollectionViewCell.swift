//
//  ExchangeCollectionViewCell.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 20.09.2023.
//

import UIKit
import SDWebImage

final class ExchangeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let exchangeStackViewLeadingInset: CGFloat = 10
            static let cryptoImageViewTopOffset: CGFloat = 15
            static let cryptoImageViewTrailingOffset: CGFloat = 15
            static let cryptoImageViewSize: CGFloat = 65
            static let volumeStackViewSpacing: CGFloat = 5
            static let exchangeStackViewSpacing: CGFloat = 5
            static let mainStackViewSpacing: CGFloat = 15
            static let cellCornerRadius: CGFloat = 15
            static let imageCornerRadius: CGFloat = 30
            
            
        }
        
        enum Text {
            static let exchangeTrustLabelText: String = "Trust Score -"
            static let dailyTradingVolumeLabelText: String = "Daily Volume -"
            static let exchangeWordOccurence: String = "Exchange"
            static let formatter: String = "%.0f %"
            static let dailyTradingVolumeValuePresicion: String = " BTC"
            static let emptyText: String = ""
        }
    }
    
    //MARK: - Private Properties
    
    private lazy var cryptoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var exchangeName: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var exchangeTrustLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = Constants.Text.exchangeTrustLabelText
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    
    private lazy var exchangeTrustScore : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var dailyTradingVolumeLabel : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.text = Constants.Text.dailyTradingVolumeLabelText
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var dailyTradingVolumeValue : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    private lazy var exchangeTrustStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            exchangeTrustLabel,
            exchangeTrustScore,
        ])
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.exchangeStackViewSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var exchangeVolumeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            dailyTradingVolumeLabel,
            dailyTradingVolumeValue,
        ])
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.volumeStackViewSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var exchangeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            exchangeName,
            exchangeTrustStackView,
            exchangeVolumeStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = Constants.Layout.mainStackViewSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstrains()
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    private func addSubviews() {
        contentView.addSubview(cryptoImageView)
        contentView.addSubview(exchangeStackView)
    }
    
    private func setupCell() {
        layer.cornerRadius = Constants.Layout.cellCornerRadius
        backgroundColor = UIColor(red: 49/255, green: 58/255, blue: 59/255, alpha: 1)
    }
    
    private func configureExchangeName(withText text: String) {
        guard text.contains (Constants.Text.exchangeWordOccurence) else {
            return exchangeName.text = text
        }
        let modifiedText = text.replacingOccurrences(
            of: Constants.Text.exchangeWordOccurence,
            with: Constants.Text.emptyText
        )
        exchangeName.text = modifiedText
    }
    
    private func addConstrains() {
        exchangeStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Constants.Layout.exchangeStackViewLeadingInset)
        }
        
        cryptoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Layout.cryptoImageViewTopOffset)
            make.trailing.equalToSuperview().inset(Constants.Layout.cryptoImageViewTrailingOffset)
            make.width.height.equalTo(Constants.Layout.cryptoImageViewSize)
        }
    }
    
    //MARK: - Methods
    
    func configure(with model : OverviewCollectionViewExchange){
        cryptoImageView.layer.cornerRadius = Constants.Layout.imageCornerRadius
        configureExchangeName(withText: model.name)
        exchangeTrustScore.text = String(model.trustScore)
        dailyTradingVolumeValue.text = String(
            format: Constants.Text.formatter,
            model.tradeVolume24HBtc
        ) + Constants.Text.dailyTradingVolumeValuePresicion
        guard let url = URL(string: String(model.image)) else {
            return
        }
        cryptoImageView.sd_setImage(with: url,completed: nil)
    }
}
