//
//  Double+Extension.swift
//  tip-calculator
//
//  Created by Soroush on 8/12/23.
//

import Foundation

extension Double {
    var currencyFormatted: String {
        // problem
        var isWholeNumber: Bool {
            isZero ? true: !isNormal ? false: self == rounded()
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = isWholeNumber ? 0 : 2
        return formatter.string(for: self) ?? ""
    }
}
