//
//  DescriptionTableViewCell.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 29.09.2023.
//

import UIKit

final class DescriptionTableViewCell: UITableViewCell {
    
    // MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let descriptionTitleTopOffset: CGFloat = 20
            static let descriptionTitleLeadingInset: CGFloat = 16
            static let descriptionLabelTopOffset: CGFloat = 20
            static let descriptionLabelLeadingTrailingInset: CGFloat = 16
            static let websiteButtonTopOffset: CGFloat = 15
            static let websiteButtonBottomOffset: CGFloat = -20
            static let websiteButtonWidth: CGFloat = 150
            static let websiteButtonHeight: CGFloat = 30
            
        }
        
        enum Text {
            static let discriptionTitleText: String = "Description"
            static let websiteButtonTitle: String = "Show Website"
            static let emptyDescriptionAlternativeText = "We do not have reliable information. Please visit the official website for details."
        }
        
    }
    
    // MARK: - Private Properties
    
    private var descriptionTitle: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = Constants.Text.discriptionTitleText
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.sizeToFit()
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.Text.websiteButtonTitle, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(openWebsite), for: .touchUpInside)
        return button
    }()
    
    private var websiteURL: URL?
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    
    private func addSubviews() {
        [
            descriptionLabel,
            websiteButton,
            descriptionTitle
        ].forEach {
            contentView.addSubview($0)
        }
        selectionStyle = .none
    }
    
    private func addConstraints() {
        descriptionTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Layout.descriptionTitleTopOffset)
            make.leading.equalToSuperview().inset(Constants.Layout.descriptionTitleLeadingInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTitle.snp.bottom).offset(Constants.Layout.descriptionLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.Layout.descriptionLabelLeadingTrailingInset)
        }
        
        websiteButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constants.Layout.websiteButtonTopOffset)
            make.bottom.equalToSuperview().offset(Constants.Layout.websiteButtonBottomOffset)
            make.width.equalTo(Constants.Layout.websiteButtonWidth)
            make.height.equalTo(Constants.Layout.websiteButtonHeight)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func openWebsite() {
        if let url = websiteURL, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            return
        }
    }
    
    //MARK: - Methods
    
    func configure(with model: CoinDetailModel) {
        let description = model.description.en.removingHTMLOccurances
        if !description.isEmpty {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = Constants.Text.emptyDescriptionAlternativeText
        }
        
        if let homepageURL = model.links.homepage.first, let url = URL(string: homepageURL) {
            websiteURL = url
        } else {
            websiteURL = nil
        }
    }
}
