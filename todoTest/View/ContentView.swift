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
    private var items: FetchedResults<Item>
    
    /* Variables D'état */
    @State var addTodo: Bool = false
    @State var pickerSelection: TypePickerSelection = .todo
    

    /* Importation ViewModel */
    @EnvironmentObject var todoVM: TodoViewModel
    
    var body: some View {
            NavigationView {
                ZStack {
                    // MARK: - Background Color
                    LinearGradient(colors: [Color(red: Double.random(in: 0.5...1), green: Double.random(in: 0.5...1), blue: Double.random(in: 0.5...1)),Color(red: Double.random(in: 0...0.5), green: Double.random(in: 0...0.5), blue: Double.random(in: 0...0.5))], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                    VStack {
                        // MARK: - Picker Selection "TODO" ou "DONE"
                        Picker("", selection: $pickerSelection) {
                            ForEach(TypePickerSelection.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        // MARK: - Liste de Tâches
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
                                        if item.expire! >= Date.now {
                                            item.isDone = true
                                        }
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
                                                print(error)
                                            }
                                            print("SUCCESS")
                                        }

                                    }
                            }
                            .onDelete(perform: deleteItems)
                            .onMove(perform: moveTodo(fromOffsets:toOffset:))
                        }
                        .scrollContentBackground(.hidden)
                        .task {
                            // MARK: - Load Data
                            todoVM.todos = await todoVM.loadData(vc: viewContext)
                        }
                        .sheet(isPresented: $addTodo, content: {
                            AddTodoView()
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
                }
            }
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



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environmentObject(TodoViewModel())
    }
}
