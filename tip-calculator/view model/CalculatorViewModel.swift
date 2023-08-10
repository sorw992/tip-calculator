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
    
    func transform(input: Input) -> Output {
        
        // bussiness logic  and calculation
        
        let result = Result(
            amountPerPerson: 500,
            totalBill: 1000,
            totalTip: 50.0)
        
        // just: to send a publisher out
        return Output(updateViewPublisher: Just(result).eraseToAnyPublisher())
        
    }
    
     
}
