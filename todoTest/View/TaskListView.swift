//
//  TaskListView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 19/01/2023.
//

import SwiftUI

struct TaskListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    var items: FetchedResults<Item>
    
    @EnvironmentObject var todoVM: TodoViewModel
    @Binding var  pickerSelection: TypePickerSelection
    var body: some View {
        List {
            ForEach(todoVM.todos.filter {pickerSelection == .todo ? !$0.isDone : $0.isDone}) { item in
                NavigationLink {
                    TodoDetailView(item: item, title: item.title ?? "No title", plot: item.plot ?? "No description", expire: item.expire ?? Date.now)
                } label: {
                    VStack(alignment: .leading) {
                        Text(item.title ?? "No title")
                            .fontWeight(.semibold)
                        Text(item.plot ?? "No Description")
                            .lineLimit(1)
                    }
                }
                .listStyle(.plain)
                .listRowBackground(Color.clear)
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
                        
                        // Envoi de la notification
                        var dateComponents = DateComponents()
                        dateComponents = Calendar.current.dateComponents([.hour,.day,.minute], from: item.expire!)
                        
                        // Création du contenu de la notification
                        let content = UNMutableNotificationContent()
                        content.title = "\(item.title!)"
                        content.subtitle = "\(item.plot!)"
                        content.sound = UNNotificationSound.default

                        // Création du déclencheur de la notification
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                        // création du random identifier et de la requete
                        let uuidString = UUID().uuidString
                        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)

                        // Création, envoi de la requete et gestion de l'erreur
                        let notificationCenter = UNUserNotificationCenter.current()
                        notificationCenter.add(request) { error in
                            if error != nil {
                                print("ERREUR")
                            }
                            print("SUCCESS")
                        }

                    }
            }
            .onDelete(perform: deleteItems)
            .onMove(perform: moveTodo(fromOffsets:toOffset:))
        }.scrollContentBackground(.hidden)
    }
    
    
    // MARK: - Fonctions
    // Fonction MoveTodo
    func moveTodo(fromOffsets source: IndexSet, toOffset destination: Int) {
        todoVM.todos.move(fromOffsets: source, toOffset: destination)
    }

    //Fonction DeleteTodo
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            do {
                Task{
                    try viewContext.save()
                    todoVM.todos = await todoVM.loadData(vc: viewContext)
                }
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(pickerSelection: .constant(.todo))
    }
}
