//
//  todoTestTests.swift
//  todoTestTests
//
//  Created by Esteban SEMELLIER on 01/03/2023.
//

import XCTest
@testable import todoTest


final class todoTestTests: XCTestCase {
    var sut: TodoViewModel!
    
    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = TodoViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }
    
    func testAdd() {
        
    }

    

}
