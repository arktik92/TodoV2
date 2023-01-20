//
//  AddTodoView.swift
//  todoTest
//
//  Created by Esteban SEMELLIER on 17/01/2023.
//

import SwiftUI
import CoreData

struct AddTodoView: View {
    // MARK: -  Variables CoreData
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - Variables d'état
    @State var title: String = ""
    @State var content: String = ""
    @State var expire: Date = Date.now
    @State var showingAlertTitleAndContent = false
    @State var showingAlertContent = false
    @State var showingAlertTitle = false
    @State var dateToggleSwitch: Bool = false
    @State var categogyPickerSelection: CategoryPickerSelection = .travail
    
    // MARK: - Variables Binding
    @Binding var addTodo: Bool
    
    // MARK: - Importation ViewModel
    @EnvironmentObject var todoVM: TodoViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                // MARK: - Bouton Ajout Todo
                Button {
                    if title != "" && content != "" {
                        if title != "" {
                            if content != "" {
                                Task {
                                    addItem(title: title, plot: content, expire: expire)
                                    todoVM.todos = await todoVM.loadData(vc: viewContext)
                                    addTodo = false
                                }
                            } else {
                                showingAlertContent = true
                            }
                        } else {
                            showingAlertTitle = true 
                        }
                    } else {
                        showingAlertTitleAndContent = true
                    }
                } label: {
                    Text("Ajouter")
                        .padding(30)
                }
                .alert("Oups ! Tu as oublié d'ajouter un titre et une description", isPresented: $showingAlertTitleAndContent) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Oups ! Tu as oublié d'ajouter une description", isPresented: $showingAlertContent) {
                    Button("OK", role: .cancel) { }
                }
                .alert("Oups ! Tu as oublié d'ajouter un titre", isPresented: $showingAlertTitle) {
                    Button("OK", role: .cancel) { }
                }
            }
            // MARK: - Formulaire
            Form {
                Section {
                    TextField("Titre", text: $title)
                    TextField("Description", text: $content, axis: .vertical)
                    
                } header: {
                    Text("Informations")
                }
                
                Section {
                    SegmentedPickerCategory(CategorypickerSelection: $categogyPickerSelection)
                }header: {
                    Text("Categorie")
                }
                Section {
                    if dateToggleSwitch {
                        DatePicker(selection: $expire, in: Date.now..., displayedComponents: .date) {
                            Text("Date")
                        }
                        DatePicker(selection: $expire, displayedComponents: .hourAndMinute) {
                            Text("heure")
                        }                        
                    }
                    
                } header: {
                    HStack {
                        Text("Date et heure")
                        Toggle(isOn: $dateToggleSwitch) {
                            EmptyView()
                        }
                    }
                }
            }
        } .background(Color(red: 0.109, green: 0.109, blue: 0.117))
    }
    // MARK: - Fonction Ajout de todo
    func addItem(title: String, plot: String, expire: Date?) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.plot = plot
            newItem.title = title
            newItem.isDone = false
            newItem.timestamp = Date()
            newItem.category = categogyPickerSelection.categoryPickerSelectionString
            newItem.dateToggleSwitch = dateToggleSwitch
            if dateToggleSwitch {
                newItem.expire = expire
                // Envoi de la notification
                
                    var dateComponents = DateComponents()
                    dateComponents = Calendar.current.dateComponents([.hour,.day,.minute], from: expire!)
                    
                    // Création du contenu de la notification
                    let content = UNMutableNotificationContent()
                    content.title = "\(title)"
                    content.subtitle = "\(plot)"
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
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#if DEBUG
struct AddTodoView_Previews: PreviewProvider {
    static var previews: some View {
        AddTodoView(expire: Date.now, addTodo: .constant(false))
            .environmentObject(TodoViewModel())
    }
}
#endif

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
