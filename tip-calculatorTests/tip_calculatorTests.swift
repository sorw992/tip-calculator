//
//  tip_calculatorUITestsLaunchTests.swift
//  tip-calculatorUITests
//
//  Created by soroush on 8/7/23.
//

import XCTest
import Combine
@testable import tip_calculator

final class tip_calculatorUITestsLaunchTests: XCTestCase {
    
    // system under test (the object we are testing)
    private var sut: CalculatorViewModel!
    
    private var cancellables: Set<AnyCancellable>!
    
    private let logoViewTapSubject = PassthroughSubject<Void, Never>()
    
    private var audioPlayerService: MockAudioPlayerService!
    
    override func setUp() {
        audioPlayerService = .init()
        sut = .init(audioPlayerService: audioPlayerService)
        cancellables = .init()
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    
    func testResultWithoutTipFor1Person() {
        
        // given
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 1
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        // when
        let output = sut.transform(input: input)
        
        // then - test output is accurate
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWithoutTipFor2Person() {
        
        let bill: Double = 100.0
        let tip: Tip = .none
        let split: Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        
        let output = sut.transform(input: input)
        
        
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 50)
            XCTAssertEqual(result.totalBill, 100)
            XCTAssertEqual(result.totalTip, 0)
        }.store(in: &cancellables)
    }
    
    func testResultWith10PercentTipFor2Person() {
      
        let bill: Double = 200.0
        let tip: Tip = .custom(value: 201)
        let split: Int = 4
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        let output = sut.transform(input: input)
        
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 100.25)
            XCTAssertEqual(result.totalBill, 401)
            XCTAssertEqual(result.totalTip, 201)
        }.store(in: &cancellables)
    }
    
    func testResultWithCustomTipFor4Person() {
        
        let bill: Double = 100.0
        let tip: Tip = .tenPercent
        let split: Int = 2
        let input = buildInput(
            bill: bill,
            tip: tip,
            split: split)
        
        
        let output = sut.transform(input: input)
        
        
        output.updateViewPublisher.sink { result in
            XCTAssertEqual(result.amountPerPerson, 55)
            XCTAssertEqual(result.totalBill, 110)
            XCTAssertEqual(result.totalTip, 10)
        }.store(in: &cancellables)
    }
    
    func testSoundPlayedAndCalculatorResetOnLogoViewTop() {
        // given
        let input = buildInput(bill: 100, tip: .tenPercent, split: 2)
        let output = sut.transform(input: input)
        
        let expectation1 = XCTestExpectation(description: "reset calculator called")
        
        let expectation2 = audioPlayerService.expectation
        
        // then - what we except when tapping on logo view
        // Note: when user taps on logo, the publisher will be fired
        output.resetCalculatorPublisher.sink { _ in
            expectation1.fulfill()
        }.store(in: &cancellables)
        
        // when - because of asynchronous code came to end
        logoViewTapSubject.send( )
        
        wait(for: [expectation1, expectation2], timeout: 1.0)
        
    }
    
    private func buildInput(bill: Double, tip: Tip, split: Int) -> CalculatorViewModel.Input {
        return .init(
            billPublisher: Just(bill).eraseToAnyPublisher(),
            tipPublisher: Just(tip).eraseToAnyPublisher(),
            splitPublisher: Just(split).eraseToAnyPublisher(),
            logoViewTapPublisher: logoViewTapSubject.eraseToAnyPublisher())
    }
    
}


// create a mock of audio player
class MockAudioPlayerService: AudioPlayerService {
    
    var expectation = XCTestExpectation(description: "playSound is called")
    
    func playSound() {
        expectation.fulfill()
    }
    
}




