//
//  BillInputView.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit

class BillInputView: UIView {
    
    init() {
        // .zero: because we use autolayout, so we dont need to care about frame
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        backgroundColor = .green
    }
    
}
