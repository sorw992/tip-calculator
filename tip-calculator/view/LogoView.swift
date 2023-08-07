//
//  LogoView.swift
//  tip-calculator
//
//  Created by macbookpro on 8/7/23.
//

import UIKit

class LogoView: UIView {
    
    init() {
        // .zero: because we use autolayout, so we dont need to care about frame
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        backgroundColor = .red
    }
    
}


