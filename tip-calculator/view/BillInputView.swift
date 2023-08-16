//
//  BillInputView.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit
import Combine
// CombineCocoa: like RxCocoa, CombineCocoa basically creates the interface to listen to  events that happening inside ui components
import CombineCocoa

class BillInputView: UIView {
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(
            topText: "Enter",
            bottomText: "your bill")
        
        return view
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8.0 )
        return view
    }()
    
    private let currencyDenominationLabel: UILabel = {
        let label = LabelFactory.build(
            text: "$",
            font: ThemeFont.bold(ofSize: 24))
        // problem
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var textField: UITextField = {
        // all the configurations for textfield
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = ThemeFont.demiBold(ofSize: 28)
        textField.keyboardType = .decimalPad
        // problem
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        // Add toolbar
        // you have to declare lazy to create an instance of UIToolbar Here.
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36))
        toolbar.barStyle = .default
        // problem
        toolbar.sizeToFit()
        let doneButton  = UIBarButtonItem(
            title: "done",
            style: .plain,
            target: self,
            action: #selector(doneButtontapped))
        // put done button on the right side of the toolbar
        toolbar.items = [
            UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil),
            doneButton
        ]
        toolbar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    // pass textfield's text to view controller
    //  subject acts as a go-between to enable non-Combine imperative code to send values to Combine subscribers
    // PassthroughSubject is an observable. for example when we observe from the text field, we can pass that information into the billSubject, can be observed by other classes.
    // View model is interested to get Double instead of String because we define Double for billPublisher in Inputs
    // Note*: PassthroughSubject and AnyPublisher both can emit values. a PassthroughSubject can accept values and emit values but AnyPublisher can only emit values (AnyPublisher is read-only).
    // Note*: why we have this two in combination? our PassthroughSubject is private but we use AnyPublisher to use it from other classes.
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    // billSubject is private so we use this:
    var valuePublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    // for releasing resources
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        // .zero: because we use autolayout, so we dont need to care about frame
        super.init(frame: .zero)
        layout()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reset() {
        textField.text = nil
        billSubject.send(0)
    }
    
    func observe() {
        textField.textPublisher.sink { [unowned self] text in
            print("text: \(text)")
            
            billSubject.send(text?.doubleValue ?? 0)
        }.store(in: &cancellable)
    }
    
    private func layout() {
        // add multiple  subviews in one line
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            // set constraints for top, right and bottom
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDenominationLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDenominationLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            // padding left 16
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            // left padding for textField
            make.leading.equalTo(currencyDenominationLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
        
    }
    
    @objc private func doneButtontapped() {
        textField.endEditing(true)
    }
    
}
