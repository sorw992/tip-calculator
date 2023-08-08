//
//  LogoView.swift
//  tip-calculator
//
//  Created by macbookpro on 8/7/23.
//

import UIKit

class LogoView: UIView {
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "icCalculatorBW"))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    
    let topLabel: UILabel = {
        let label = UILabel()
        
        let text = NSMutableAttributedString(
            string: "Mr TIP",
            attributes: [.font: ThemeFont.demiBold(ofSize: 16)])
        // range: NSMakeRange(3, 3): sets "TIP"'s text size to 24
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(3, 3))
        label.attributedText = text
        return label
    }()
    
    let bottomLabel: UILabel = {
        LabelFactory.build(
            text: "Calculator",
            font: ThemeFont.demiBold(ofSize: 20),
            textAlignment: .left)
    }()
    
    private lazy var hStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            
            imageView,
            vStackView
            
        ])
        
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .center
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            topLabel,
            bottomLabel
        ])
        view.axis = .vertical
        view.spacing = -4
        view.alignment = .center
        return view
    }()
    
    init() {
        // .zero: because we use autolayout, so we dont need to care about frame
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {
        addSubview(hStackView)
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
        
    }
    
}
