//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit
import Combine
import CombineCocoa

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
        
        button.tapPublisher.flatMap { [unowned self] _ in
            // spltInputView's number shoudn't be less than 1
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(
            text: "+",
            // layerMaxXMinYCorner: top right
            // layerMaxXMaxYCorner: bottom right
            corners: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        
        // flatMap transforms all elements into a new publisher
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value + 1)
        }.assign(to: \.value, on: splitSubject)
            .store(in: &cancellables)
        
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
    
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    var valuePublisher: AnyPublisher<Int, Never> {
        // removeDuplicates(): when quantityLabel's number is 1 and user taps negative button, we dont need to emit 1 again. it preventing redundant and repetitious
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // .zero: because we use autolayout, so we dont need to care about frame
        super.init(frame: .zero)
        
        layout()
        observe()
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
    
    private func observe() {
        splitSubject.sink { [weak self] quantity in
            guard let self = self else {return}
            quantityLabel.text = quantity.stringValue
        }.store(in: &cancellables)
         
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
