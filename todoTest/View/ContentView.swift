//
//  ContentView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData
import UserNotifications

// TODO: Ajouter Notifications

struct ContentView: View {
    /* Variables CoreData */
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    var items: FetchedResults<Item>

    /* Variables D'état */
    @State var addTodo: Bool = false
    @State var pickerSelection: TypePickerSelection = .todo
    

    /* Importation ViewModel */
    @EnvironmentObject var todoVM: TodoViewModel
    
    /* Variable Anim SpashScreen */
    @State var showSplash = true

    var body: some View {
         
            NavigationView {
                ZStack {
                    // MARK: - Background Color
                    BackgroundColor()
                    VStack {
                        // MARK: - Picker Selection "TODO" ou "DONE"
                        SegmentedPickerTodoOrDone(pickerSelection: $pickerSelection)
                        
                        // MARK: - Liste de Tâches
                        TaskListView( pickerSelection: $pickerSelection)
                        
                        .task {
                            // MARK: - Load Data
                            todoVM.todos = await todoVM.loadData(vc: viewContext)
                        }
                        .sheet(isPresented: $addTodo, content: {
                            AddTodoView(addTodo: $addTodo)
                        })
                        // MARK: - Toolbar
                        .toolbar {
                            ToolbarItem {
                                Button {
                                    print("XXXXXXXX: go to add todo")
                                    addTodo.toggle()
                                } label: {
                                    Image(systemName: "plus")
                                }
                                
                            }
                        }
                    }
                    .navigationTitle("Todo List")
                    .navigationBarTitleDisplayMode(.inline)
                    SplashScreen()
                      .opacity(showSplash ? 1 : 0)
                      .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                          SplashScreen.shouldAnimate = false
                          withAnimation() {
                            self.showSplash = false
                          }
                        }
                    }
                }
                .onAppear {
                 //DispatchQueue.main.asyncAfter(date limite : .now() + 2) {
                // withAnimation() {
                // self.showSplash = false
                // }
                //}
                }
            }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(TodoViewModel())
    }
}