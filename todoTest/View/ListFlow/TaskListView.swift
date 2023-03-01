//
//  TaskListView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 19/01/2023.
//

import SwiftUI

struct TaskListView: View {
    // MARK: - Variables CoreData
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    var items: FetchedResults<Item>
    
    // MARK: - ImportationViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    
    // MARK: -  Variable Binding
    @Binding var  pickerSelection: TypePickerSelection
    
    var body: some View {
        List {
            ForEach(todoVM.todos.filter {pickerSelection == .todo ? !$0.isDone : $0.isDone}) { item in
                NavigationLink {
                    TodoDetailView(item: item, title: item.title ?? "No title", plot: item.plot ?? "No description", expire: item.expire ?? Date.now)
                } label: {
                    ListCellView(item: item)
                }
                .listStyle(.plain)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .padding()
                .background(
                    Color(red: Double.random(in: 0.5...1), green: Double.random(in: 0.5...1), blue: Double.random(in: 0.5...1))
                        .cornerRadius(25)
                        .shadow(radius: 5, x: 10, y: 10)
                )
                .onAppear {
                    // MARK: - Notifications
                    // Demande d'accès Notification
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                        if success {
                            print("All set!")
                        } else if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
                .swipeActions(edge: .leading) {
                    ShareLink(item: "Je te partage ma nouvelle Todo: \n\(item.title ?? "No title")\n\(item.plot ?? "No  description")")
                }
            }
            .onDelete { indexSet in
                todoVM.deleteItems(offsets: indexSet, vc: viewContext, items: items)
            }
            .onMove(perform: todoVM.moveTodo(fromOffsets:toOffset:))
        }
        .scrollContentBackground(.hidden)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(pickerSelection: .constant(.todo))
            .environmentObject(TodoViewModel())
    }
}
