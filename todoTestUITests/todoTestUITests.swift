//
//  todoTestUITests.swift
//  todoTestUITests
//
//  Created by Esteban SEMELLIER on 01/03/2023.
//

import XCTest

func testAddwithoutDate() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    sleep(5)
    // Navigation to addView
    XCTAssert(app.navigationBars.element.buttons.element.exists)
    app.navigationBars.element.buttons.element.tap()
    
    // Renomage des éléments
    let addButton = app.buttons["add"]
    let titleTexfield = app.textFields["Titre"]
    let descriptionTexfield = app.textFields["Description"]
    let segmentedPicker = app.segmentedControls["categoryPicker"]
    let hourAndDateSwitch = app.switches["switcher"]
    
    // Test if elements exist
    XCTAssert(addButton.exists)
    XCTAssert(titleTexfield.exists)
    XCTAssert(descriptionTexfield.exists)
    XCTAssert(segmentedPicker.exists)
    XCTAssert(hourAndDateSwitch.exists)
    
    // Fill Textfields
    // title Texfield
    titleTexfield.tap()
    titleTexfield.typeText("Ceci est un titre sans date")
    // Description textField
    descriptionTexfield.tap()
    descriptionTexfield.typeText("Ceci est une description sans date")
    
    // Select category on category picker
    segmentedPicker.buttons["Maison"].tap()
    
    // Save
    addButton.tap()
    sleep(3)
}
func testAddwithDate() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    sleep(5)
    // Navigation to addView
    XCTAssert(app.navigationBars.element.buttons.element.exists)
    app.navigationBars.element.buttons.element.tap()
    
    // Renomage des éléments
    let addButton = app.buttons["add"]
    let titleTexfield = app.textFields["Titre"]
    let descriptionTexfield = app.textFields["Description"]
    let segmentedPicker = app.segmentedControls["categoryPicker"]
    let hourAndDateSwitch = app.switches["switcher"]
    let dateField = app.datePickers["dateField"]
    let hourField = app.datePickers["hourField"]
    
    // Test if elements exist
    XCTAssert(addButton.exists)
    XCTAssert(titleTexfield.exists)
    XCTAssert(descriptionTexfield.exists)
    XCTAssert(segmentedPicker.exists)
    XCTAssert(hourAndDateSwitch.exists)
    
    // Fill Textfields
    // title Texfield
    titleTexfield.tap()
    titleTexfield.typeText("Ceci est un titre avec date")
    // Description textField
    descriptionTexfield.tap()
    descriptionTexfield.typeText("Ceci est une description avec date")
    
    // Select category on category picker
    segmentedPicker.buttons["Maison"].tap()
    
    // Switch the toggle
    hourAndDateSwitch.tap()
    
    // Verify if datePickers exists
    XCTAssert(dateField.exists && hourField.exists)
    
    // Save
    addButton.tap()
    sleep(5)
}

final class todoTestUITests: XCTestCase {
    func testAddTodo() throws {
        try testAddwithDate()
        try testAddwithoutDate()
    }
}
