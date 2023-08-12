//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by Soroush on 8/10/23.
//

import Foundation
import Combine

class CalculatorViewModel {
    
    struct Input {
        // get values from viewcontroller
        
        // never: this publishers will never return failure or error
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
    }
    
    struct Output {
        // send values to  view controller to send to the result view's (total p/person - total bill - totalbill) labels
        let updateViewPublisher: AnyPublisher<Result, Never>
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        
        // bussiness logic  and calculation
        
        
        
        // CombineLates: is a functiont that we use if any of the publishers (billPublisher, tipPublisher and splitPublisher publishers change)
        // CombineLates3: since we observing three publishers (billPublisher, tipPublisher and splitPublisher). if you have 4 publishers you can use CombineLatest4().
        // if any of this publishers emit a value, we want to recompute everything
        // flatMap transforms updateViewPublisher into the type of AnyPublisher<Result, Never>
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher).flatMap { [unowned self] (bill, tip, split) in
                
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: amountPerPerson)
                return Just(result)
            }.eraseToAnyPublisher()
    
        // just: to send a publisher out
        return Output(updateViewPublisher: updateViewPublisher)
        
    }
    
    func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return Double(value)
        }
    }
    
}
