//
//  CryptoDataView.swift
//  CryptoTraceX
//
//  Created by Mac Book Air M1 on 19.09.2023.
//

import UIKit

final class CryptoDataView: UIStackView {
    
    // MARK: - Constants
    
    enum Constants {
        enum Layout {
            static let exchangeStackViewLeadingInset: CGFloat = 10
        }
        
        enum Text {
            static let formatType2f: String = "%.2f %%"
            static let formatType5f: String = "%.5f %%"
            static let millionFormatType: String = "%.2fTn"
            static let billionFormatType: String = "%.2fBn"
            static let trillionFormatType: String = "%.2fM"
            static let dollar : String = " $"
            static let emptyText = ""
        }
        
        enum Numbers {
            static let oneValue : Double = 1.0
        }
        
        enum Formats : Double {
            case trillion = 1000000000000
            case billion = 1000000000
            case million = 1000000
            case thousand = 1000
        }
        
        enum CryptoDataType {
            case percent
            case currency
            case industryRank
        }
        
        enum ScreenType {
            case mainScreen
            case detailScreen
        }
    }
    
    // MARK: - Private Properties
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .lightGray
        title.textAlignment = .left
        return title
    }()
    
    private let dataLabel: UILabel = {
        let dataLabel = UILabel()
        dataLabel.textColor = .white
        dataLabel.textAlignment = .left
        return dataLabel
    }()
    
    // MARK: - Init
    
    init(title: String, purpose: Constants.ScreenType) {
        super.init(frame: .zero)
        setupView()
        setTitle(title)
        configureFontSizes(for: purpose)
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        addArrangedSubview(titleLabel)
        addArrangedSubview(dataLabel)
        axis = .vertical
        alignment = .center
    }
    
    private func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func configureFontSizes(for puprose: Constants.ScreenType) {
        switch puprose {
        case .mainScreen:
            titleLabel.font = UIFont.systemFont(ofSize: 12)
            dataLabel.font = UIFont.systemFont(ofSize: 18)
        case .detailScreen:
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            dataLabel.font = UIFont.systemFont(ofSize: 18)
        }
    }
    
    private func formatCryptoValue(_ value: Double, dataType: Constants.CryptoDataType) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        var formattedValue: String
        
        if dataType == .currency {
            if value >= Constants.Formats.million.rawValue {
                let formats: [(Double, String)] = [
                    (Constants.Formats.trillion.rawValue, Constants.Text.millionFormatType),
                    (Constants.Formats.billion.rawValue, Constants.Text.billionFormatType),
                    (Constants.Formats.million.rawValue, Constants.Text.trillionFormatType)
                ]
                
                for (limit, format) in formats {
                    if value >= limit {
                        let formattedValueAboveLimit = value / limit
                        return String(format: format + Constants.Text.dollar, formattedValueAboveLimit)
                    }
                }
            }
            formattedValue = formatter.string(from: NSNumber(value: value)) ?? Constants.Text.emptyText
            formattedValue += Constants.Text.dollar
        } else if dataType == .percent {
            if value >= Constants.Numbers.oneValue && value <= .zero {
                formattedValue = String(format: Constants.Text.formatType5f, value)
            } else {
                formattedValue = String(format: Constants.Text.formatType2f, value)
            }
        } else if dataType == .industryRank {
            formattedValue = String((Int(value)))
        } else {
            formattedValue = formatter.string(from: NSNumber(value: value)) ?? Constants.Text.emptyText
        }
        
        return formattedValue
    }
    
    // MARK: - Methods
    
    func setData(value: Double, dataType: Constants.CryptoDataType) {
        switch dataType {
        case .percent:
            let formattedValue = String(
                format: Constants.Text.formatType2f, value
            )
            dataLabel.text = formattedValue
        case .currency:
            let formattedValue = formatCryptoValue(value, dataType: dataType)
            dataLabel.text = formattedValue
        case .industryRank:
            dataLabel.text = String((Int(value)))
        }
    }
}
