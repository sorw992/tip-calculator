//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Choose",
            bottomText: "your tip")
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        
        // CombineCocoa
        // flatMap transfers one publisher to another
        // tapPublisher.flatMap: every time the button is being tapped, (flatMap): i'm gonna transform this tao event into another publisher and Just is that publisher.
        button.tapPublisher.flatMap {
            // returns another publisher
            // Just: A publisher that emits an output to each subscriber just once, and then finishes.
            Just(Tip.tenPercent) // send this information (Tip.tenPercent) to tipSubject via the value property (\.value).
        }.assign(to: \.value, on: tipSubject) // \.value is value property of the tipSubject. tipSubject.value
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellables)
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Custom Tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        button.addCornerRadius(radius: 8.0)
        
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancellables)
        
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton
        ])
        
        // width of these three buttons is equal
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        
        let stackView = UIStackView(arrangedSubviews: [
        buttonHStackView,
        customTipButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        // height of buttonHStackView and customTipButton is equal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // CurrentValueSubject: subject can receive the data and publish the data.
    // why didn't we use PassThroughSubject here? because CurrentValueSubject allows us to give it default value while PassThroughObject doesn't let us
    // we passed it default value .none. at start there is not tip has been set
    // .none is initial value of our CurrentValueSubject
    private let tipSubject = CurrentValueSubject<Tip, Never>(.none)
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // .zero: because we use autolayout, so we dont need to care about frame
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func layout() {

        [headerView, buttonVStackView].forEach(addSubview(_:))
        
        // first we define top, right and bottom constraints of buttonVStackView
        buttonVStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }

        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
        
    }
    
    private func handleCustomTipButton() {
        let alertController: UIAlertController = {
            let controller = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            controller.addTextField { textField in
                textField.placeholder = "Make it generous"
                // users unabled to enter alphabetical characters
                textField.keyboardType = .numberPad
                // we dont want any suggestion
                // problem
                textField.autocorrectionType = .no
                
            }
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            
            let okAcrion = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    // pass value to tipSubject
                    guard let text = controller.textFields?.first?.text,
                          let value = Int(text) else { return }
                    self?.tipSubject.send(.custom(value: value))
                }
            
            // add actions inside alert controller
            [okAcrion, cancelAction].forEach(controller.addAction(_:))
            return controller
        }()
        
        // get parent viewcontroller for uiview itlself to present alertcontroller
        parentViewController?.present(alertController, animated: true)
    }
    
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8.0)
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(ofSize: 20),
                .foregroundColor: UIColor.white
            ])
        
        text.addAttributes([
        
            .font: ThemeFont.demiBold(ofSize: 14)
        
        ], range: NSMakeRange(2, 1 )) // NSMakeRange(2, 1 ): differentsize for "%" text
        
        button.setAttributedTitle(text, for: .normal)
        return button
    }
    
}
