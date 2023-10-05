//  CoinHeaderView.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 17.09.2023.
//

import UIKit

final class CoinHeaderView: UIView {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let descriptionStackViewSpacing: CGFloat = 30
            static let descriptionStackViewLeadingInset: CGFloat = 10
            static let priceCounterLabelTrailingInset: CGFloat = -10
            static let reloadButtonTrailingInset: CGFloat = 15
            static let reloadButtonWidthAndHeight: CGFloat = 15
        }
        
        enum Text {
            static let rateCounterLabelText: String = "Rate"
            static let coinCounterLabelText: String = "Coin"
            static let priceCounterLabelText: String = "Price / Volatility"
        }
        
        enum Image {
            static let imageName: String = "reload.svg"
        }
    }
    // MARK: - Private Properties
    
    private lazy var rateCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = Constants.Text.rateCounterLabelText
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var coinCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = Constants.Text.coinCounterLabelText
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var priceCounterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = Constants.Text.priceCounterLabelText
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var reloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(
            UIImage(named: Constants.Image.imageName)?
                .withTintColor(.gray, renderingMode: .alwaysOriginal),
            for: .normal
        )
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(pressedButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var descriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            rateCounterLabel,
            coinCounterLabel,
        ])
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.descriptionStackViewSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - Properties
    
    var completionHandler: (() -> Void)?
    
    //MARK: - Init
    
    init(frame: CGRect, shouldShowPriceLabel: Bool, shouldShowReloadButton : Bool) {
        super.init(frame: frame)
        priceCounterLabel.isHidden = !shouldShowPriceLabel
        reloadButton.isHidden = !shouldShowReloadButton
        setupView()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        [
            descriptionStackView,
            reloadButton,
            priceCounterLabel
        ].forEach {
            addSubview($0)
        }
    }
    
    private func addConstraints() {
        descriptionStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Layout.descriptionStackViewLeadingInset)
            make.centerY.equalToSuperview()
        }
        
        priceCounterLabel.snp.makeConstraints { make in
            make.trailing.equalTo(reloadButton.snp.leading).inset(Constants.Layout.priceCounterLabelTrailingInset)
            make.centerY.equalToSuperview()
        }
        
        reloadButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.Layout.reloadButtonTrailingInset)
            make.width.height.equalTo(Constants.Layout.reloadButtonWidthAndHeight)
        }
    }
    
    // MARK: - Methods
    
    @objc private func pressedButton() {
        completionHandler?()
    }
}
