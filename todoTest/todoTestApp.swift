//
//  todoTestApp.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI

@main
struct todoTestApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var todoVM = TodoViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(todoVM)
                .preferredColorScheme(.light)
        }
    }
}
