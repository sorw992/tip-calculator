//
//  ViewController.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorViewController: UIViewController {
    
    private let logoView = LogoView ()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            // space view with UIVIew() - solve an error related to stackview
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    
    
    private let vm = CalculatorViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // add gesture recognizer to view (to sismiss keyboard when user taps outside the keyboard)
    // AnyPublisher is a read-only publisher and we set Void, because we dont need to pass any value. when the user taps outside the keyboard.
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        // flatMap transforms AnyPublisher<UITapGestureRecognizer, Never> to AnyPublisher<Void, Never>
        return tapGesture.tapPublisher.flatMap { ـ in // returns UITapGestureRecognizer and we dont need it "_"
            // transform UITapGestureRecognizer to Void
            // () represents the Void
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    // when user taps twice on logo on top, all the form fields is resetting
    // need to double tap on this two to qualify this as logoViewTapPublisher
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tapGesture)
        // flatMap transforms AnyPublisher<UITapGestureRecognizer, Never> to AnyPublisher<Void, Never>
        return tapGesture.tapPublisher.flatMap { ـ in // returns UITapGestureRecognizer and we dont need it "_"
            // transform UITapGestureRecognizer to Void
            // () represents the Void
            Just(())
        }.eraseToAnyPublisher()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
        observe()
    }
    
    // bind viewcontroller to viewmodel
    private func bind() {
        
        let input = CalculatorViewModel.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher)
        
        let output = vm.transform(input: input)
        
        // will delete soon
        
        // observe output received from view model
        // sink subscriber: The sink subscriber allows you to provide closures with your code that will receive output values and completions. From there, you can do anything with the received events.
        // we can receive any result output from publisher.
        output.updateViewPublisher.sink { [unowned self] result in
            print(">>>> \(result)")
            resultView.configure(result: result)
            // problem: &
        }.store(in: &cancellables)
    }
    
    func observe() {
        viewTapPublisher.sink { [unowned self] value in
            // dismiss keyboard
            view.endEditing(true)
        }.store(in: &cancellables)
        
        logoViewTapPublisher.sink { _ in
            print("logo view is tapped")
        }.store(in: &cancellables)
    }
    
    private func layout() {
        
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        
        // use snapkit to autolayout views
        vStackView.snp.makeConstraints { make in
            // pin stackview inside container
            // we have padding on top, bottom, left, right
            
            //left side
            // view.snp.leadingMargin: if user roates the phone it can take care of edges
            // offset: add padding
            make.leading.equalTo(view.snp.leadingMargin).offset(16)
            make.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            make.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            make.top.equalTo(view.snp.topMargin).offset(16)
            
        }
        
        logoView.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints { make in
            make.height.equalTo(224 )
        }
        
        billInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints { make in
            make.height.equalTo(56+56+16)
        }
        
        splitInputView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
    }
    
}
