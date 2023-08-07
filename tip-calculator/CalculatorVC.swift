//
//  ViewController.swift
//  tip-calculator
//
//  Created by Soroush on 8/7/23.
//

import UIKit
import SnapKit

class CalculatorVC: UIViewController {
    
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
        splitInputView
        ])
        stackView.axis = .vertical
        stackView.spacing = 36
        return stackView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    
    private func layout() {
        
        view.backgroundColor = .white
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
