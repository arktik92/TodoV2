//
//  todoTestTests.swift
//  todoTestTests
//
//  Created by Esteban SEMELLIER on 01/03/2023.
//

import XCTest
import SwiftUI
import CoreData
@testable import todoTest



final class todoTestTests: XCTestCase {
    // Variables Tests
    let viewContext = PersistenceController(inMemory: true).container.viewContext
    @ObservedObject var vm = TodoViewModel()
    



    func testAddFunction() {
        
        let title = "UnitTestAddFunctionTitle"
        let plot = "UnitTestAddFunctionDescription"
        let expire = Date.now
        let dateToggleSwitch = false
        let categoryPickerSelection: CategoryPickerSelection = .maison
        
        let item = vm.addItem(title: title, plot: plot, expire: expire, categogyPickerSelection: categoryPickerSelection, dateToggleSwitch: dateToggleSwitch, vc: viewContext)

        
        print(item)
        XCTAssertEqual(item.title, title)
        XCTAssertEqual(item.plot, plot)
        if item.dateToggleSwitch {
            XCTAssertEqual(item.expire, expire)
        }
        XCTAssertEqual(item.dateToggleSwitch, dateToggleSwitch)
    }
    func testSaveItem() {
        // Add Item
        Task {
            vm.todos = await vm.loadData(vc: viewContext)
            let item2 = vm.addItem(title: "titleBeforeUpdate", plot: "plotBeforeUpdate", expire: Date.now, categogyPickerSelection: .maison, dateToggleSwitch: false, vc: viewContext)
            vm.saveItem(item: item2, title: "title" , plot: "Description" , categogyPickerSelection: .travail, expire: Date.now , vc: viewContext)
            let todos = await vm.loadData(vc: viewContext)
            print(todos.count)
        }
        
            }
    
//    func testMoveItem() {
//        // Creation des variables de tests
//        let firstItem = vm.addItem(title: "FirstItemTitle", plot: "FirstItemDescription", expire: Date.now, categogyPickerSelection: .maison, dateToggleSwitch: false, vc: viewContext)
//        let secondItem = vm.addItem(title: "SecondItemTitle", plot: "SecondItemDescription", expire: Date.now, categogyPickerSelection: .sport, dateToggleSwitch: false, vc: viewContext)
//
//        // Creation et implementation de la liste de test
//        var items = [Item]()
//        items.append(firstItem)
//        items.append(secondItem)
//
//
//
//        print(items[0].title ?? "No title")
//        vm.moveTodo(fromOffsets: ([1]), toOffset: 2)
//        print(items[0].title ?? "No Title2")
//
//    }
    
    
    
//    func testDeleteItem() {
//        vm.addItem(title: "deleteTitle", plot: "DeleteDescription", expire: Date.now, categogyPickerSelection: .maison, dateToggleSwitch: false, vc: viewContext)
//
//
//    }


}
