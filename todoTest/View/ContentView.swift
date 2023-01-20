//
//  ContentView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData


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
    @State var dateToggleSwitch: Bool = false

    
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
                    TaskListView(pickerSelection: $pickerSelection)
                        .task {
                            // MARK: - Load Data
                            todoVM.todos = await todoVM.loadData(vc: viewContext)
                        }
                        .sheet(isPresented: $addTodo, content: {
                            AddTodoView(addTodo: $addTodo)
                                .presentationDetents([.medium, .large])
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
//                .navigationTitle("Todo List")
                .navigationBarTitleDisplayMode(.inline)
                //TODO: Decommenter .onAppear
//                SplashScreen() // MARK: - 3.Appeler SplashScreen, lui donner une opacité et le .onAppear
//                    .opacity(showSplash ? 1 : 0) //
//                    .onAppear { //
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 6) { //
//                            SplashScreen.shouldAnimate = false //
//                            withAnimation() { //
//                                self.showSplash = false //
//                            } //
//                        } //
//                    } // Fin .onAppear
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Todo List")
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(TodoViewModel())
    }
}
#endif
