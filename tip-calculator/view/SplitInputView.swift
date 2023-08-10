//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit


class SplitInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildButton(
            text: "-",
            // layerMinXMinYCorner: top left
            // layerMinXMaxYCorner: bottom left
            corners: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(
            text: "+",
            // layerMaxXMinYCorner: top right
            // layerMaxXMaxYCorner: bottom right
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        
        let label = LabelFactory.build(
            text: "1",
            font: ThemeFont.bold(ofSize: 20),
            backgroundColor: .white)
        
        return label
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        return stackView
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

        [headerView, stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        // add width constraints for buttons
        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.centerY.equalTo(stackView.snp.centerY)
            make.width.equalTo(68)
        }

    }
    
    private func buildButton(text: String, corners: CACornerMask) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.addRoundedCorners(corners: corners, radius: 8.0)
        button.backgroundColor = ThemeColor.primary
        return button
    }
    
}
