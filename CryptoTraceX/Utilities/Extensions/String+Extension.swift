//
//  String+Extension.swift
//  CryptoTraceX
//
//
//  Created by Mac Book Air M1 on 29.09.2023.
//

import Foundation

extension String {

    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
