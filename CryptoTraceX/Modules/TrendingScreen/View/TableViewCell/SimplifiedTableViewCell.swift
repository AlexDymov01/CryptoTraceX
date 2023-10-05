//
//  SimplifiedTableViewCell.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 28.09.2023.
//

import UIKit
import SnapKit
import SDWebImage

final class SimplifiedTableViewCell: UITableViewCell {
    
    //MARK: - Private Constants
    
    private enum Constants {
        enum Layout {
            static let infoStackViewSpacing: CGFloat = 15
            static let infoStackViewLeadingInset: CGFloat = 10
            static let infoStackViewHeight: CGFloat = 50
            static let detailImageViewTrailingInset: CGFloat = 10
            static let detailImageViewHeight: CGFloat = 20
            static let trendingRankLabelWidth: CGFloat = 35
            static let cryptoNameTrailingInset: CGFloat = -10
            static let cryptoImageViewSize: CGFloat = 50
        }
        
        enum Image {
            static let detailImage: String = "chevron.right"
        }
        
        enum Value {
            static let trendingRankLabelId: Int = 1
        }
    }
    
    //MARK: - Private Properties
    
    private lazy var trendingRankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var cryptoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var cryptoNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = .white
        return imageView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            trendingRankLabel,
            cryptoImageView,
            cryptoNameLabel
            
        ])
        stackView.axis = .horizontal
        stackView.spacing = Constants.Layout.infoStackViewSpacing
        stackView.alignment = .leading
        return stackView
    }()
    
    //MARK: - Init
    
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
            infoStackView,
            detailImageView
        ].forEach { stackView in
            addSubview(stackView)
        }
    }
    
    private func setupConstraints() {
        infoStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constants.Layout.infoStackViewLeadingInset)
            make.centerY.equalToSuperview()
            make.height.equalTo(Constants.Layout.infoStackViewHeight)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Constants.Layout.detailImageViewTrailingInset)
            make.height.width.equalTo(Constants.Layout.detailImageViewHeight)
        }
        
        trendingRankLabel.snp.makeConstraints { make in
            make.width.height.equalTo(Constants.Layout.trendingRankLabelWidth)
            make.centerY.equalToSuperview()
        }
        
        cryptoNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(detailImageView.snp.leading).inset(Constants.Layout.cryptoNameTrailingInset)
        }
        
        cryptoImageView.snp.makeConstraints { make in
            make.height.width.equalTo(Constants.Layout.cryptoImageViewSize)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: -  Methods
    
    func configure(with model: Item, id: Int){
        cryptoNameLabel.text = String(describing: model.name)
        detailImageView.image = UIImage(systemName: Constants.Image.detailImage)
        trendingRankLabel.text = String(id + Constants.Value.trendingRankLabelId)
        
        guard let url = URL(string: String(describing: model.large)) else {
            return
        }
        cryptoImageView.sd_setImage(with: url, completed: nil)
    }
}
